#!/bin/bash

# Renk ve biçim tanımları
RED='\033[1;31m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'
CYAN='\033[0;36m'

INSTALL_DIR="."
BROKER_CONFIG="./broker.toml"

# Yardımcı fonksiyonlar
info() { echo -e "${BLUE}[INFO]${RESET} $1"; }
success() { echo -e "${CYAN}[OK]${RESET} $1"; }
prompt() { echo -en "${CYAN}$1${RESET}"; }

# Broker ayarlarını yapılandır (GÜNCEL HAL)
configure_broker() {
    info "Broker ayarları yapılandırılıyor..."

    # Eğer broker.toml yoksa, template'ten oluştur
    if [[ ! -f "$BROKER_CONFIG" ]]; then
        cp "./boundless/broker-template.toml" "$BROKER_CONFIG"
        success "broker.toml oluşturuldu."
    else
        info "broker.toml zaten mevcut. Mevcut dosya üzerinden ayarlar yapılacak."
    fi

    while true; do
        clear
        echo -e "${RED}${BOLD}		⚙️ BROKER AYARLARI ⚙️${RESET}"
        echo -e "Lütfen ayarı seçiniz (çıkmak için 'q' tuşuna basın):"
        echo -e "1) 🔧 mcycle_price"
        echo -e "2) ⚡ peak_prove_khz"
        echo -e "3) 🧮 max_mcycle_limit"
        echo -e "4) ⏳ min_deadline"
        echo -e "5) 🧵 max_concurrent_proofs"
        echo -e "6) 🔥 lockin_priority_gas"
        echo -e "7) 🔙 Geri dön"

        read -rp "Seçiminiz: " choice

        case $choice in
            q|Q|7)
                info "Broker ayarlarından çıkılıyor..."
                break
                ;;
            1)
                prompt "🔧 mcycle_price [varsayılan: 0.0000005, çıkmak için 'q']: "
                read -r val
                if [[ "$val" == "q" ]]; then info "mcycle_price ayarından çıkıldı." ; else
                    val=${val:-0.0000005}
                    sed -i "s/mcycle_price = \"[^\"]*\"/mcycle_price = \"$val\"/" "$BROKER_CONFIG"
                    success "mcycle_price başarıyla güncellendi: $val"
                    read -n 1 -s -r -p "Devam etmek için bir tuşa basın..."
                fi
                ;;
            2)
                prompt "⚡ peak_prove_khz [varsayılan: 100, çıkmak için 'q']: "
                read -r val
                if [[ "$val" == "q" ]]; then info "peak_prove_khz ayarından çıkıldı." ; else
                    val=${val:-100}
                    sed -i "s/peak_prove_khz = [0-9]*/peak_prove_khz = $val/" "$BROKER_CONFIG"
                    success "peak_prove_khz başarıyla güncellendi: $val"
                    read -n 1 -s -r -p "Devam etmek için bir tuşa basın..."
                fi
                ;;
            3)
                prompt "🧮 max_mcycle_limit [varsayılan: 8000, çıkmak için 'q']: "
                read -r val
                if [[ "$val" == "q" ]]; then info "max_mcycle_limit ayarından çıkıldı." ; else
                    val=${val:-8000}
                    sed -i "s/max_mcycle_limit = [0-9]*/max_mcycle_limit = $val/" "$BROKER_CONFIG"
                    success "max_mcycle_limit başarıyla güncellendi: $val"
                    read -n 1 -s -r -p "Devam etmek için bir tuşa basın..."
                fi
                ;;
            4)
                prompt "⏳ min_deadline [varsayılan: 300, çıkmak için 'q']: "
                read -r val
                if [[ "$val" == "q" ]]; then info "min_deadline ayarından çıkıldı." ; else
                    val=${val:-300}
                    sed -i "s/min_deadline = [0-9]*/min_deadline = $val/" "$BROKER_CONFIG"
                    success "min_deadline başarıyla güncellendi: $val"
                    read -n 1 -s -r -p "Devam etmek için bir tuşa basın..."
                fi
                ;;
            5)
                prompt "🧵 max_concurrent_proofs [varsayılan: 2, çıkmak için 'q']: "
                read -r val
                if [[ "$val" == "q" ]]; then info "max_concurrent_proofs ayarından çıkıldı." ; else
                    val=${val:-2}
                    sed -i "s/max_concurrent_proofs = [0-9]*/max_concurrent_proofs = $val/" "$BROKER_CONFIG"
                    success "max_concurrent_proofs başarıyla güncellendi: $val"
                    read -n 1 -s -r -p "Devam etmek için bir tuşa basın..."
                fi
                ;;
            6)
                prompt "🔥 lockin_priority_gas [varsayılan: 0, çıkmak için 'q']: "
                read -r val
                if [[ "$val" == "q" ]]; then info "lockin_priority_gas ayarından çıkıldı." ; else
                    val=${val:-0}
                    if grep -q "^#lockin_priority_gas" "$BROKER_CONFIG"; then
                        sed -i "s/^#lockin_priority_gas.*/lockin_priority_gas = $val/" "$BROKER_CONFIG"
                    elif grep -q "^lockin_priority_gas" "$BROKER_CONFIG"; then
                        sed -i "s/^lockin_priority_gas.*/lockin_priority_gas = $val/" "$BROKER_CONFIG"
                    else
                        echo "lockin_priority_gas = $val" >> "$BROKER_CONFIG"
                    fi
                    success "lockin_priority_gas başarıyla güncellendi: $val"
                    read -n 1 -s -r -p "Devam etmek için bir tuşa basın..."
                fi
                ;;
            *)
                info "Geçersiz seçim, lütfen tekrar deneyin."
                ;;
        esac
    done
}
# Ana menü
show_main_menu() {
    local options=("Broker Ayarları")
    local selected=0

    while true; do
        clear
        echo -e "${RED}${BOLD}                   🍇🍇🍇 BOUNDLESS MENÜ 🍇🍇🍇${RESET}\n"
        echo -e "${BLUE}Ok tuşlarıyla gez, Enter ile seç, çıkmak için 'q' tuşuna bas${RESET}\n"

        for i in "${!options[@]}"; do
            if [[ $i -eq $selected ]]; then
                echo -e " > ${CYAN}⚙️ ${options[$i]}${RESET}"
            else
                echo "  ⚙️ ${options[$i]}"
            fi
        done

        read -rsn1 key
        case "$key" in
            $'\x1b')
                read -rsn2 -t 0.1 key2
                case "$key2" in
                    '[A') ((selected--)) ;;
                    '[B') ((selected++)) ;;
                esac
                ;;
            '')  # Enter
                case $selected in
                    0) configure_broker ;;
                esac
                ;;
            q) exit 0 ;;
        esac

        ((selected < 0)) && selected=0
        ((selected >= ${#options[@]})) && selected=$((${#options[@]} - 1))
    done
}

# Başlat
show_main_menu
