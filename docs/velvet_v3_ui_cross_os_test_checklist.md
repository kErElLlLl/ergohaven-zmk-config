# Velvet v3 UI — чек-лист теста cross-OS раскладки

Кеймап: `config/velvet_v3_ui_ruen.keymap` (сборки `velvet_v3_ui_right_ruen`,
`velvet_v3_ui_qube_ruen` в `build.yaml`). Дизайн: `docs/superpowers/specs/2026-08-10-velvet-v3-ui-cross-os-keymap-design.md`.

## Перед началом

Один раз в каждой ОС назначить **Ctrl+Space** = "переключить источник ввода
(next input source)":

- **macOS**: уже дефолт (System Settings → Keyboard → Keyboard Shortcuts →
  Input Sources → Select next input source). Проверить, что не переопределено.
- **Windows**: Settings → Time & Language → Language & region → Advanced
  keyboard settings → Input language hot keys → назначить Ctrl+Space как
  "Switch Input Language" (Between input languages). Если системный диалог
  не даёт задать произвольную комбинацию — переназначить через PowerToys
  Keyboard Manager (Win+Space → Ctrl+Space).
- **Linux**: ibus/fcitx — в настройках input method назначить Ctrl+Space
  как trigger-хоткей переключения раскладки.

На клавиатуре: `adj`-слой → `bt_mac`/`bt_win`/`bt_lin` (там, где раньше были
`BT_SEL 0/1/2`) — подключить и выбрать нужный профиль на каждой машине один раз.

## Компиляция

- [ ] CI (`.github/workflows/build.yml`) зелёный на пуше/PR с изменённым
      `velvet_v3_ui_ruen.keymap`.
- [ ] `scripts/check-keymap-layers.sh config/velvet_v3_ui_ruen.keymap`
      выводит "All 11 layers have 46 bindings. OK."

## Ручная проверка на железе

| Проверка | Mac | Windows | Linux |
|---|---|---|---|
| `bt_mac`/`bt_win`/`bt_lin` подключает нужный профиль | ☐ | ☐ | ☐ |
| Copy/Paste/Cut/Undo/Redo/SelectAll/Save/Find — один и тот же палец (S=primary, F=secondary модификатор) на всех трёх | ☐ | ☐ | ☐ |
| RU-буквы печатаются корректно (ЙЦУКЕН на месте) — комбо позиций 3+4 из EN | ☐ | ☐ | ☐ |
| Ctrl+Space переключает RU↔EN раскладку ОС и клавиатура остаётся синхронизирована | ☐ | ☐ | ☐ |
| Комбо позиций 3+4 из RU возвращает в EN | ☐ | ☐ | ☐ |
| Все 12 "трудных" символов `{ } @ # $ ~ ^ & | [ ] < >` печатаются верно в RU-режиме (sym_ru → `&en ...`) | ☐ | ☐ | ☐ |
| Обычные символы sym_en/sym_ru (`, . / ; ' [ ] ( ) - = ! ?` и т.д.) на месте в обоих языках | ☐ | ☐ | ☐ |
| После переключения хоста (bt_mac/bt_win/bt_lin) язык сбрасывается на EN, RU-комбо снова работает | ☐ | ☐ | ☐ |
| Trackball: движение поднимает mouse-слой, скролл/снайпер-подслои работают как раньше | ☐ | ☐ | ☐ |
| Nav/Adj/Mouse/Scroll/Sniper слои не изменились по ощущениям от прежнего `velvet_v3_ui.keymap` | ☐ | ☐ | ☐ |
