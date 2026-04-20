#!/bin/bash

set -e  # Прерываем выполнение при ошибке

DOTFILES_REPO="https://github.com/smirniagin/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

brew_packages=(
  starship
  fzf
  eza
  yazi
  bat
  btop
  stow
  lazygit
  kubectl
  kubectx
  k9s
  golangci-lint
)

brew_casks=(
  ghostty
)

# Установка Homebrew, для macOS
if ! command -v brew &> /dev/null; then
  if [ "$(uname)" == "Darwin" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Добавляем brew в PATH сразу после установки
    echo "📌 Добавляем Homebrew в PATH..."

    BREW_PREFIX=$(/opt/homebrew/bin/brew --prefix 2>/dev/null || /usr/local/bin/brew --prefix)

    if [[ "$SHELL" == */zsh ]]; then
      echo "eval \"\$(${BREW_PREFIX}/bin/brew shellenv)\"" >> "$HOME"/.zprofile
      eval "$("${BREW_PREFIX}"/bin/brew shellenv)"
    elif [[ "$SHELL" == */bash ]]; then
      echo "eval \"\$(${BREW_PREFIX}/bin/brew shellenv)\"" >> "$HOME"/.bash_profile
      eval "$("${BREW_PREFIX}"/bin/brew shellenv)"
    else
      echo "⚠️ Неизвестный шелл. Добавьте путь вручную:"
      echo "eval \"\$(${BREW_PREFIX}/bin/brew shellenv)\""
    fi

    echo "✅ Homebrew установлен"
  fi
else
  echo "✅ Homebrew найден."
fi
# ==== Установка cask-пакетов ====
for pkg in "${brew_casks[@]}"; do
    echo "📦 Устанавливаем cask: $pkg"
    brew install --cask "$pkg"
done

# ==== Установка обычных brew-пакетов ====
for pkg in "${brew_packages[@]}"; do
    echo "📦 Устанавливаем: $pkg"
    brew install "$pkg"
done

# ==== Клонирование dotfiles ====
echo "📦 Клонируем dotfiles из $DOTFILES_REPO..."
if [ -d "$DOTFILES_DIR" ]; then
    echo "⚠️ Каталог $DOTFILES_DIR уже существует. Пропускаем клонирование."
else
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

# ==== Применение через stow ====
echo "📂 Применяем конфигурации через stow..."
cd "$DOTFILES_DIR"
stow .

echo "✅ Установка завершена!"
