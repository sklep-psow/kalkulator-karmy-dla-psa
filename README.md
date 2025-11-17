# 🐕 Kalkulator Karmy dla Psa

Profesjonalna aplikacja webowa do obliczania dziennej porcji karmy dla psów, stworzona w technologii Flutter.

![App Icon](web/icons/Icon-192.png)

## 📋 Opis

Kalkulator Karmy dla Psa to zaawansowane narzędzie, które pomaga właścicielom psów określić właściwą dzienną porcję karmy dla ich pupili. Aplikacja uwzględnia wiele czynników wpływających na zapotrzebowanie energetyczne psa, dostarczając precyzyjne rekomendacje.

## ✨ Funkcje

### Główne parametry kalkulacji:
- **Waga psa** - wprowadź wagę swojego psa w kilogramach
- **Etap życia** - szczeniak (różne przedziały wiekowe), dorosły, senior
- **Rasa** - uwzględnia specyficzne potrzeby różnych ras
- **Aktywność** - od rekonwalescencji do hiperaktywności
- **Kondycja ciała** - od zbyt chudego do otyłego
- **Sterylizacja** - czy pies jest sterylizowany/kastrowany
- **Energia metabolizowalna (EM)** - wartość kaloryczna karmy (kcal/100g)

### Dodatkowe funkcje:
- 📊 **Tabela referencyjna** - szybkie oszacowanie ilości karmy dla różnych wag
- 🧮 **Precyzyjny algorytm** - oparty na profesjonalnych metodach obliczania zapotrzebowania energetycznego (BEE)
- 📱 **Responsywny design** - działa na wszystkich urządzeniach
- 🇵🇱 **Polski interfejs** - w pełni spolonizowana aplikacja
- 🔗 **Link do psów.pl** - dostęp do dodatkowych zasobów i porad

## 🎯 Metoda obliczania

Aplikacja wykorzystuje naukowo potwierdzoną metodę obliczania Podstawowego Zapotrzebowania Energetycznego (BEE):

- **Dla psów < 9 kg:** BEE = 130 × waga^0,75
- **Dla psów > 9 kg:** BEE = 156 × waga^0,667

Następnie stosuje współczynniki dla:
- Rasy (0.8 - 1.2)
- Aktywności (0.7 - 1.2)
- Etapu życia (1.0 - 2.0)
- Kondycji ciała (0.8 - 1.2)
- Sterylizacji (0.8 lub 1.0)

## 🚀 Technologie

- **Flutter 3.35.4** - framework do tworzenia aplikacji wieloplatformowych
- **Dart 3.9.2** - język programowania
- **Material Design 3** - nowoczesny design system
- **url_launcher** - do obsługi linków zewnętrznych

## 📦 Instalacja i uruchomienie

### Wymagania:
- Flutter SDK 3.35.4 lub nowszy
- Dart SDK 3.9.2 lub nowszy

### Kroki instalacji:

```bash
# Sklonuj repozytorium
git clone https://github.com/TWOJE_KONTO/kalkulator-karmy-dla-psa.git
cd kalkulator-karmy-dla-psa

# Pobierz zależności
flutter pub get

# Uruchom aplikację w trybie debug
flutter run -d chrome

# Zbuduj wersję produkcyjną dla web
flutter build web --release

# Zbuduj APK dla Android
flutter build apk --release
```

## 🌐 Demo online

Aplikacja jest dostępna online: [Link do demo]

## 📱 Zrzuty ekranu

### Formularz kalkulacji
Intuicyjny formularz z wszystkimi parametrami potrzebnymi do obliczenia porcji karmy.

### Wynik obliczeń
Jasna prezentacja wyniku z ostrzeżeniem o konsultacji z weterynarzem.

### Tabela referencyjna
Szybkie oszacowanie dla najpopularniejszych wag psów.

## 🔗 Powiązane zasoby

Dla więcej informacji o karmieniu psów, odwiedź **[najlepsze produkty dla psów](https://psów.pl/)** - profesjonalne porady, recenzje karm i produktów dla psów.

## ⚠️ Ważne informacje

**Uwaga:** Wszystkie wartości podane przez kalkulator są jedynie szacunkowe. Nie zastępują one profesjonalnej porady weterynaryjnej. Zawsze konsultuj się z weterynarzem w sprawie odpowiedniej diety dla swojego psa.

## 🤝 Wkład w projekt

Chcesz pomóc w rozwoju projektu? Oto jak możesz się zaangażować:

1. Fork repozytorium
2. Stwórz branch dla swojej funkcji (`git checkout -b feature/NowaFunkcja`)
3. Commit swoich zmian (`git commit -m 'Dodaj nową funkcję'`)
4. Push do brancha (`git push origin feature/NowaFunkcja`)
5. Otwórz Pull Request

## 📄 Licencja

Ten projekt jest dostępny na licencji MIT - szczegóły w pliku [LICENSE](LICENSE)

## 📧 Kontakt

Masz pytania lub sugestie? Otwórz Issue na GitHubie!

## 🙏 Podziękowania

Metoda obliczania oparta na pracach dr Géraldine Blanchard, specjalistki w dziedzinie żywienia weterynaryjnego.

Źródło referencyjne: [Animaute.fr](https://www.animaute.fr/blog/chien-alimentation-quantite-croquettes)

---

**Stworzono z ❤️ dla wszystkich miłośników psów**

🐾 **[Odwiedź psów.pl](https://psów.pl/)** - Twoje źródło wiedzy o psach
