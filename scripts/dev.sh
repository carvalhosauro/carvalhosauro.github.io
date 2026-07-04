#!/usr/bin/env bash
# Dev helper for local use or inside the Dev Container.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

info() { printf '\033[0;32m[INFO]\033[0m %s\n' "$*"; }
error() { printf '\033[0;31m[ERROR]\033[0m %s\n' "$*" >&2; }

require_hugo() {
  if ! command -v hugo >/dev/null 2>&1; then
    error "Hugo não encontrado. Use o Dev Container ou instale Hugo Extended ≥ 0.146."
    exit 1
  fi
}

slugify() {
  echo "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g'
}

cmd_server() {
  require_hugo
  info "Servidor em http://localhost:1313"
  hugo mod tidy
  exec hugo server -D --bind 0.0.0.0 --baseURL http://localhost:1313/
}

cmd_build() {
  require_hugo
  hugo mod tidy
  hugo --gc --minify
  info "Build em ./public"
}

cmd_new_post() {
  require_hugo
  local lang="${1:-}"
  local title="${2:-}"

  if [[ -z "$lang" || -z "$title" ]]; then
    error "Uso: ./scripts/dev.sh new-post <pt-br|en> \"Título do post\""
    exit 1
  fi

  if [[ "$lang" != "pt-br" && "$lang" != "en" ]]; then
    error "Idioma inválido: $lang (use pt-br ou en)"
    exit 1
  fi

  local slug
  slug="$(slugify "$title")"
  local path="content/${lang}/posts/${slug}/index.md"

  hugo new "content/${lang}/posts/${slug}/index.md" --kind posts
  info "Post criado: ${path}"
  info "Edite o arquivo, defina draft: false e use o mesmo translationKey na tradução."
}

usage() {
  cat <<'EOF'
Uso: ./scripts/dev.sh <comando>

Comandos:
  server                         Hugo server com drafts (porta 1313)
  build                          Gera ./public
  new-post <pt-br|en> "Título"   Cria post no idioma indicado
  help                           Mostra esta ajuda
EOF
}

main() {
  case "${1:-help}" in
    server) cmd_server ;;
    build) cmd_build ;;
    new-post)
      shift
      cmd_new_post "${1:-}" "${2:-}"
      ;;
    help|--help|-h) usage ;;
    *)
      error "Comando desconhecido: $1"
      usage
      exit 1
      ;;
  esac
}

main "$@"
