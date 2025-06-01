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
)

brew_casks=(
  ghostty
)

# Установка Homebrew, для macOS
if [ "$(uname)" == "Darwin" ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "brew установлен"
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