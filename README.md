# Landing Page Challenge (Jekyll)

Este projeto foi convertido para **Jekyll** e está pronto para publicar no **GitHub Pages**.

## 1) Setup no Windows (uma vez)

### Instalar Ruby + DevKit
Opção recomendada: [RubyInstaller for Windows](https://rubyinstaller.org/)

Durante a instalação:
- marque a opção para adicionar Ruby ao `PATH`
- ao final, execute o `ridk install` e selecione os componentes padrão (MSYS2)

### Verificar instalação
```powershell
ruby -v
gem -v
```

## 2) Instalar dependências do projeto
No diretório do projeto:
```powershell
gem install bundler
bundle install
```

## 3) Rodar localmente
```powershell
bundle exec jekyll serve --livereload
```
Acesse:
- http://127.0.0.1:4000/

## 4) Publicar no GitHub Pages (automático)
Este repositório já contém workflow em `.github/workflows/jekyll.yml`.

No GitHub:
1. Vá em **Settings > Pages**
2. Em **Build and deployment**, escolha **Source: GitHub Actions**
3. Faça push para a branch principal (`main`)
4. Aguarde o workflow concluir em **Actions**

## Comandos úteis
```powershell
bundle exec jekyll build
bundle update
```

## Como adicionar conteúdo novo
Cada menu do site lê automaticamente uma coleção Jekyll. Para publicar um item novo, basta criar um arquivo `.md` na pasta correta.

Coleções disponíveis:
- `_desafios/`
- `_computacao_quantica/`
- `_arquiteturas/`
- `_design_patterns/`

Exemplo mínimo:
```md
---
title: "CQRS"
description_title: "Visão geral do padrão CQRS e quando aplicar."
status: "Rascunho"
tags:
	- "arquitetura"
	- "cqrs"
aprendizado:
	- "Separação entre leitura e escrita."
requisitos_html: |
	<ul>
		<li>Explicar motivação e trade-offs.</li>
	</ul>
---

## Resumo

Conteúdo do artigo em Markdown.
```

Depois rode:
```powershell
bundle exec jekyll build
```

## Sincronizar `data.json` em posts de desafios
Se você ainda quiser aproveitar o arquivo `src/Config/data.json`, ele pode ser convertido automaticamente para a coleção `_desafios/`.

Execute:
```powershell
./scripts/sync-desafios-from-json.ps1
```

Esse comando:
- gera/atualiza os arquivos `.md` em `_desafios/`
- atualiza `_data/desafios.json`
- remove arquivos antigos de `_desafios/` que não existem mais no `data.json`

Fluxo recomendado antes do push:
```powershell
./scripts/sync-desafios-from-json.ps1
bundle exec jekyll serve --livereload
```

## Estrutura Jekyll usada
- `_config.yml`: configuração do site
- `_layouts/`: layouts base
- `_includes/`: componentes compartilhados (header)
- `_desafios/`: coleção de desafios
- `_computacao_quantica/`: coleção de computação quântica
- `_arquiteturas/`: coleção de arquiteturas
- `_design_patterns/`: coleção de design patterns
- `_data/desafios.json`: dados auxiliares
- `index.html`, `desafios.html`, `computacao-quantica.html`, `arquiteturas.html`, `design-patterns.html`: páginas principais
