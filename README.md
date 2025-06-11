# 🎯 Flutter Modular Project Scaffold

Bu proje, modüler mimariyle organize edilmiş bir Flutter uygulama iskeletidir. Tema ve dil değişimi gibi temel özelliklerle birlikte gelir. Yeni projelere hızlıca başlamak için idealdir.

## 🚀 Proje Özellikleri

- Flutter modüler yapıya uygun klasör organizasyonu
- `flutter_bloc` ile durum yönetimi
- `go_router` ile sayfa yönlendirme
- `flutter_screenutil` ile responsive tasarım
- `intl` ve `flutter_localizations` ile çoklu dil desteği (Türkçe ve İngilizce)
- `build_runner` ile localization ve asset jenerasyonu
- Tema (light/dark) ve dil değişimi desteği
- Otomatikleştirilmiş proje oluşturma scripti (PowerShell)

## 🗂️ Klasör Yapısı
lib/                                                                                                                                                                                    
├── core/                                                                                                                                                                                                                    
│   └── router/                                                                                                                                                                                        
│       └── router.dart                                                                                                                                                                                                                                        
├── data/
│   ├── classes/
│   ├── constants/
│   │   ├── app_theme.dart
│   │   ├── color_const.dart
│   │   └── page_const.dart
│   └── models/
├── l10n/
│   ├── intl_en.arb
│   └── intl_tr.arb
├── presentation/
│   ├── auth/
│   │   ├── cubits/
│   │   ├── screens/
│   │   └── widgets/
│   ├── home/
│   │   ├── cubits/
│   │   ├── screens/
│   │   │   └── home_screen.dart
│   │   └── widgets/
│   ├── onboarding/
│   │   ├── cubits/
│   │   ├── screens/
│   │   └── widgets/
│   ├── profile/
│   │   ├── cubits/
│   │   ├── screens/
│   │   └── widgets/
│   ├── settings/
│   │   ├── cubits/
│   │   ├── screens/
│   │   └── widgets/
│   └── shared/
│   │   ├── cubits/
│   │   │   ├── theme_cubit.dart
│   │   │   └── locale_cubit.dart
│   │   ├── screens/
│   │   └── widgets/

## 🧩 Kullanılan Paketler

| Paket | Açıklama |
|-------|----------|
| `flutter_bloc` | State yönetimi |
| `go_router` | Yönlendirme sistemi |
| `flutter_screenutil` | Responsive tasarım için |
| `intl` / `flutter_localizations` | Çoklu dil desteği |
| `flutter_svg` | SVG desteği |
| `build_runner`, `flutter_gen_runner`, `intl_utils` | Otomatik kod üretimi |

## ⚙️ Kurulum ve Çalıştırma

1. Flutter SDK’nın yüklü olduğundan emin olun.
2. Projeyi klonlayın veya oluşturduğunuz klasöre girin.
3. Ardından MAC || LINUX terminalinizde bu komutu çalıştırın:
    ./flutter_modular_starter.sh
4. Projenize isim vermeniz istenilecek ve dosyanın olduğu konuma projenizi oluşturacak.

📄 Lisans

Bu proje MIT lisansı ile lisanslanmıştır. Detaylar için LICENSE dosyasına bakınız.
