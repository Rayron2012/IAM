#!/usr/bin/env python3
"""Recalcula a barra pública a partir de curriculum/progress.yml.

A barra júnior soma só os itens obrigatórios das fases 1 a 5.
As fases 6 a 10 entram no contador de diferenciais.
Itens opcionais têm peso 0 e ficam de fora das duas contas.

Uso:
  python3 scripts/atualizar-progresso.py
  python3 scripts/atualizar-progresso.py --check
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
PROGRESSO = ROOT / "curriculum" / "progress.yml"
README = ROOT / "README.md"
TRILHA = ROOT / "docs" / "trilha-iam.html"
BADGE_JUNIOR = ROOT / "docs" / "progresso-junior.svg"
BADGE_EXTRA = ROOT / "docs" / "progresso-diferenciais.svg"

INICIO = "<!-- PROGRESSO:INICIO -->"
FIM = "<!-- PROGRESSO:FIM -->"

# Pastas já existentes. A trilha não ganha fase nova por este script.
PASTAS = {
    "f1": "01-fundamentos",
    "f2": "02-active-directory",
    "f3": "03-microsoft-entra-id",
    "f4": "04-protocolos-sso",
    "f5": "05-iga",
    "f6": "06-pam",
    "f7": "07-cloud-iam",
    "f8": "08-automacao",
    "f9": "09-compliance",
    "f10": "10-entrevista-portfolio",
}

JUNIOR_IDS = ["f1", "f2", "f3", "f4", "f5"]
EXTRA_IDS = ["f6", "f7", "f8", "f9", "f10"]

INTRO_ANTIGA = (
    "Esta pasta começa sem evidência. O checklist abaixo sai da trilha de estudos "
    "e fica desmarcado até você fazer o item. Laboratório não é produção."
)
INTRO_NOVA = (
    INTRO_ANTIGA
    + " O id entre crases na caixa é o mesmo de `curriculum/progress.yml` e de `docs/trilha-iam.html`."
)


def porcentagem(feitos: int, total: int) -> int:
    """Inteiro, metade para cima. 0 se não houver peso."""
    if total <= 0:
        return 0
    return (feitos * 100 + total // 2) // total


def barra(pct: int, largura: int = 20) -> str:
    cheios = (pct * largura + largura // 2) // 100
    cheios = max(0, min(largura, cheios))
    return "█" * cheios + "░" * (largura - cheios)


def carregar() -> dict:
    with PROGRESSO.open(encoding="utf-8") as arquivo:
        dados = yaml.safe_load(arquivo)
    if not isinstance(dados, dict):
        raise SystemExit("curriculum/progress.yml não é um mapa.")
    return dados


def carregar_trilha() -> dict:
    html = TRILHA.read_text(encoding="utf-8")
    encontrado = re.search(
        r'<script id="data" type="application/json">(.*?)</script>',
        html,
        re.S,
    )
    if not encontrado:
        raise SystemExit("JSON da trilha não encontrado em docs/trilha-iam.html.")
    return json.loads(encontrado.group(1))


def validar(dados: dict, trilha: dict) -> None:
    fases = dados.get("fases")
    if not isinstance(fases, list) or len(fases) != 10:
        raise SystemExit("progress.yml precisa ter exatamente as 10 fases da trilha.")

    meta = dados.get("meta_junior") or {}
    if meta.get("fases") != JUNIOR_IDS:
        raise SystemExit(
            "meta_junior.fases tem de ser f1 a f5. "
            "A barra júnior não mistura as fases 6 a 10."
        )

    fases_html = trilha["phases"]
    if len(fases_html) != 10:
        raise SystemExit("A trilha interativa deixou de ter 10 fases.")

    ids_vistos: set[str] = set()
    for indice, fase in enumerate(fases):
        esperado = f"f{indice + 1}"
        if fase.get("id") != esperado:
            raise SystemExit(f"Fase fora de ordem: esperava {esperado}, veio {fase.get('id')}.")
        if fase.get("pasta") != PASTAS[esperado]:
            raise SystemExit(f"{esperado}: pasta {fase.get('pasta')!r} não é a pasta do repositório.")
        trilha_nome = "junior" if esperado in JUNIOR_IDS else "diferencial"
        if fase.get("trilha") != trilha_nome:
            raise SystemExit(f"{esperado}: trilha deveria ser {trilha_nome}.")

        html_fase = fases_html[indice]
        if html_fase["id"] != esperado:
            raise SystemExit(f"Id da fase na trilha HTML divergiu: {html_fase['id']}.")
        if fase.get("titulo") != html_fase["n"]:
            raise SystemExit(
                f"{esperado}: título do YAML ({fase.get('titulo')!r}) "
                f"difere da trilha ({html_fase['n']!r})."
            )
        if fase.get("duracao") != html_fase["dur"]:
            raise SystemExit(f"{esperado}: duração do YAML difere da trilha.")

        itens = fase.get("itens")
        html_itens = html_fase["items"]
        if not isinstance(itens, list) or len(itens) != len(html_itens):
            raise SystemExit(f"{esperado}: quantidade de itens difere da trilha.")

        for item, html_item in zip(itens, html_itens):
            item_id = item.get("id")
            if item_id != html_item["id"]:
                raise SystemExit(
                    f"{esperado}: id {item_id!r} difere da trilha ({html_item['id']!r}). "
                    "Mantenha a mesma ordem e os mesmos ids."
                )
            if item_id in ids_vistos:
                raise SystemExit(f"Id repetido: {item_id}")
            ids_vistos.add(item_id)
            if item.get("titulo") != html_item["t"]:
                raise SystemExit(
                    f"{item_id}: título do YAML difere da trilha.\n"
                    f"  yml:   {item.get('titulo')!r}\n"
                    f"  trilha:{html_item['t']!r}"
                )
            opcional_html = bool(html_item.get("opt"))
            if bool(item.get("obrigatorio")) == opcional_html:
                raise SystemExit(f"{item_id}: flag obrigatório diverge da trilha.")
            peso = item.get("peso")
            if opcional_html:
                if peso != 0:
                    raise SystemExit(f"{item_id}: item opcional precisa ter peso 0.")
            elif not isinstance(peso, int) or peso < 1:
                raise SystemExit(f"{item_id}: item obrigatório precisa ter peso inteiro >= 1.")
            if not isinstance(item.get("done"), bool):
                raise SystemExit(f"{item_id}: done precisa ser true ou false.")


def somar(fase: dict) -> tuple[int, int]:
    feitos = 0
    total = 0
    for item in fase["itens"]:
        if not item["obrigatorio"]:
            continue
        total += item["peso"]
        if item["done"]:
            feitos += item["peso"]
    return feitos, total


def resumo(dados: dict) -> dict:
    junior_feitos = junior_total = extra_feitos = extra_total = 0
    for fase in dados["fases"]:
        feitos, total = somar(fase)
        if fase["trilha"] == "junior":
            junior_feitos += feitos
            junior_total += total
        else:
            extra_feitos += feitos
            extra_total += total
    return {
        "junior_feitos": junior_feitos,
        "junior_total": junior_total,
        "junior_pct": porcentagem(junior_feitos, junior_total),
        "extra_feitos": extra_feitos,
        "extra_total": extra_total,
        "extra_pct": porcentagem(extra_feitos, extra_total),
    }


def linha_fase(fase: dict) -> str:
    feitos, total = somar(fase)
    marca = "☑" if total and feitos == total else "☐"
    numero = fase["numero"]
    titulo = fase["titulo"]
    pasta = fase["pasta"]
    return (
        f"| [{numero}. {titulo}]({pasta}/README.md) "
        f"| {fase['duracao']} | {feitos}/{total} | {marca} |"
    )


def render_bloco(dados: dict, stats: dict) -> str:
    junior = [fase for fase in dados["fases"] if fase["trilha"] == "junior"]
    extra = [fase for fase in dados["fases"] if fase["trilha"] == "diferencial"]
    linhas = [
        "A barra **júnior** soma os pesos dos itens obrigatórios das fases 1 a 5.",
        "O peso padrão de cada obrigatório é 1. Itens opcionais têm peso 0 e ficam de fora.",
        "As fases 6 a 10 formam o contador de **diferenciais** e não movem a porcentagem júnior.",
        "",
        (
            f"![Meta júnior: {stats['junior_pct']}% "
            f"({stats['junior_feitos']} de {stats['junior_total']})]"
            f"(docs/progresso-junior.svg)"
        ),
        "",
        (
            f"`{barra(stats['junior_pct'])}` **{stats['junior_pct']}%** júnior "
            f"({stats['junior_feitos']}/{stats['junior_total']} na soma dos pesos)"
        ),
        "",
        (
            f"![Diferenciais: {stats['extra_pct']}% "
            f"({stats['extra_feitos']} de {stats['extra_total']})]"
            f"(docs/progresso-diferenciais.svg)"
        ),
        "",
        (
            f"`{barra(stats['extra_pct'])}` **{stats['extra_pct']}%** diferenciais "
            f"({stats['extra_feitos']}/{stats['extra_total']} na soma dos pesos), fora da meta júnior"
        ),
        "",
        "100% na barra júnior é o marco **júnior apto**: todos os obrigatórios das fases 1 a 5.",
        "Concluir também os obrigatórios das fases 6 a 10 é o marco de base técnica mais ampla (pleno apto na trilha).",
        "",
        "### Trilha júnior (fases 1 a 5)",
        "",
        "| Fase | Duração sugerida | Peso feito | Status |",
        "| --- | --- | --- | --- |",
        *[linha_fase(fase) for fase in junior],
        "",
        "### Diferenciais (fases 6 a 10)",
        "",
        "| Fase | Duração sugerida | Peso feito | Status |",
        "| --- | --- | --- | --- |",
        *[linha_fase(fase) for fase in extra],
        "",
        "Gerado por `scripts/atualizar-progresso.py` a partir de `curriculum/progress.yml`.",
    ]
    return "\n".join(linhas)


def xml(texto: str) -> str:
    return (
        texto.replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace('"', "&quot;")
    )


def render_svg(rotulo: str, pct: int, feitos: int, total: int, cor: str) -> str:
    largura_barra = 230
    preenchido = largura_barra * pct / 100
    titulo = f"{rotulo}: {pct}% ({feitos} de {total})"
    return (
        '<svg xmlns="http://www.w3.org/2000/svg" width="420" height="28" '
        f'role="img" aria-label="{xml(titulo)}">\n'
        f"  <title>{xml(titulo)}</title>\n"
        '  <rect width="420" height="28" rx="6" fill="#1d2433"/>\n'
        f'  <rect x="8" y="9" width="{largura_barra}" height="10" rx="5" fill="#2a3343"/>\n'
        f'  <rect x="8" y="9" width="{preenchido:.2f}" height="10" rx="5" fill="{cor}"/>\n'
        '  <text x="248" y="19" fill="#e6e9ef" '
        'font-family="Segoe UI, system-ui, sans-serif" font-size="13" font-weight="700">'
        f"{pct}% · {feitos}/{total}</text>\n"
        "</svg>\n"
    )


def aplicar_readme(bloco: str, checar: bool) -> bool:
    texto = README.read_text(encoding="utf-8")
    padrao = re.compile(re.escape(INICIO) + r".*?" + re.escape(FIM), re.S)
    if not padrao.search(texto):
        raise SystemExit("README.md sem os marcadores PROGRESSO:INICIO / PROGRESSO:FIM.")
    novo = INICIO + "\n" + bloco + "\n" + FIM
    atualizado = padrao.sub(novo, texto, count=1)
    if atualizado == texto:
        return False
    if checar:
        return True
    README.write_text(atualizado, encoding="utf-8")
    return True


def sincronizar_fase(fase: dict, checar: bool) -> bool:
    caminho = ROOT / fase["pasta"] / "README.md"
    texto = caminho.read_text(encoding="utf-8")
    original = texto
    if INTRO_ANTIGA in texto and "curriculum/progress.yml" not in texto:
        texto = texto.replace(INTRO_ANTIGA, INTRO_NOVA, 1)

    feitos, total = somar(fase)
    fase_feita = total > 0 and feitos == total
    marca = "x" if fase_feita else " "
    palavra = "concluída" if fase_feita else "não concluída"
    linha_fase = f"- [{marca}] Fase {palavra} (`{fase['id']}`)"
    texto, trocas = re.subn(
        r"^- \[[ xX]\] Fase (?:não concluída|concluída)(?: \(`"
        + re.escape(fase["id"])
        + r"`\))?[ \t]*\n+",
        linha_fase + "\n\n",
        texto,
        count=1,
        flags=re.M,
    )
    if trocas != 1:
        raise SystemExit(f"Caixa da fase não encontrada em {caminho}.")

    linhas = texto.splitlines()
    titulos = {item["titulo"]: item for item in fase["itens"]}
    encontrados: set[str] = set()
    for indice, linha in enumerate(linhas):
        titulo = re.fullmatch(r"### (.+)", linha)
        if not titulo or titulo.group(1) not in titulos:
            continue
        item = titulos[titulo.group(1)]
        for proximo in range(indice + 1, min(indice + 6, len(linhas))):
            if re.match(r"^- \[[ xX]\] ", linhas[proximo]):
                corpo = re.sub(r"^- \[[ xX]\] ", "", linhas[proximo])
                corpo = re.sub(r"\s*`" + re.escape(item["id"]) + r"`\s*$", "", corpo).rstrip()
                caixa = "x" if item["done"] else " "
                linhas[proximo] = f"- [{caixa}] {corpo} `{item['id']}`"
                encontrados.add(item["id"])
                break
        else:
            raise SystemExit(f"Caixa do item {item['id']} não encontrada em {caminho}.")

    faltando = [item["id"] for item in fase["itens"] if item["id"] not in encontrados]
    if faltando:
        raise SystemExit(f"Itens sem caixa em {caminho}: {', '.join(faltando)}")

    texto = "\n".join(linhas) + "\n"
    if texto == original:
        return False
    if checar:
        return True
    caminho.write_text(texto, encoding="utf-8")
    return True


def escrever_se_mudou(caminho: Path, conteudo: str, checar: bool) -> bool:
    atual = caminho.read_text(encoding="utf-8") if caminho.exists() else None
    if atual == conteudo:
        return False
    if checar:
        return True
    caminho.parent.mkdir(parents=True, exist_ok=True)
    caminho.write_text(conteudo, encoding="utf-8")
    return True


def main(argv: list[str]) -> int:
    checar = "--check" in argv
    dados = carregar()
    trilha = carregar_trilha()
    validar(dados, trilha)
    stats = resumo(dados)
    bloco = render_bloco(dados, stats)
    mudou = aplicar_readme(bloco, checar)
    mudou = escrever_se_mudou(
        BADGE_JUNIOR,
        render_svg(
            "Meta júnior",
            stats["junior_pct"],
            stats["junior_feitos"],
            stats["junior_total"],
            "#3b5bdb",
        ),
        checar,
    ) or mudou
    mudou = escrever_se_mudou(
        BADGE_EXTRA,
        render_svg(
            "Diferenciais",
            stats["extra_pct"],
            stats["extra_feitos"],
            stats["extra_total"],
            "#e67700",
        ),
        checar,
    ) or mudou
    for fase in dados["fases"]:
        mudou = sincronizar_fase(fase, checar) or mudou

    if checar and mudou:
        print("Progresso dessincronizado. Rode: python3 scripts/atualizar-progresso.py")
        return 1

    print(
        f"Júnior {stats['junior_pct']}% "
        f"({stats['junior_feitos']}/{stats['junior_total']}). "
        f"Diferenciais {stats['extra_pct']}% "
        f"({stats['extra_feitos']}/{stats['extra_total']})."
    )
    return 0


if __name__ == "__main__":
    if "--self-test" in sys.argv:
        assert porcentagem(0, 39) == 0
        assert porcentagem(1, 39) == 3
        assert porcentagem(20, 39) == 51
        assert porcentagem(39, 39) == 100
        assert barra(0) == "░" * 20
        assert barra(100) == "█" * 20
        print("self-test ok")
    sys.exit(main(sys.argv[1:]))
