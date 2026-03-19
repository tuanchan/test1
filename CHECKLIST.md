# CHECKLIST — SpacedRep Flutter App

## App Core
- [ ] App compile sans erreur (`flutter pub get && flutter run`)
- [ ] Aucune erreur dart analyze bloquante
- [ ] 12 demo tasks chargées au démarrage
- [ ] State management Provider fonctionne (mutations propagées à tous les widgets)

## UI / Theme
- [ ] Theme cam đậm #FF4A00 appliqué partout (accent, badges, boutons)
- [ ] Nền đen #0A0A0A sur tout l'app
- [ ] Surface #141414 pour les cards
- [ ] Typography claire, hiérarchie lisible
- [ ] Bo góc lớn sur toutes les cards (16px+)
- [ ] Spacing rộng rãi (pas d'éléments collés)
- [ ] Shadow nhẹ sur les cards

## Tab Bar
- [ ] Floating blur tab bar visible en bas
- [ ] BackdropFilter / ImageFilter.blur actif (effect visible)
- [ ] Tab active en couleur #FF4A00
- [ ] Tab inactive en gris discret
- [ ] Switching entre tabs fluide
- [ ] Tab bar ne cache pas le contenu (padding bottom correct)
- [ ] Bo góc floating bar (radius 28)

## Tab Home
- [ ] Dashboard: 3 stats (Total / Đã thuộc / Cần ôn)
- [ ] CTA card "Hôm nay cần ôn" visible et cliquable
- [ ] Card "Cách hoạt động" avec les mốc 1/3/7/14/30
- [ ] Tap sur CTA ouvre le bottom sheet

## Tab Tasks
- [ ] Liste des 12 tasks visible
- [ ] Chaque card affiche: titre, statut badge, mốc, ngày ôn tiếp theo
- [ ] Mini timeline visible sur les tasks apprise
- [ ] Bouton "Đã thuộc" actif si task chưa thuộc
- [ ] Bouton "Hủy thuộc" actif si task đã thuộc
- [ ] Filter chips: Tất cả / Chưa thuộc / Đang theo lịch / Đến hạn hôm nay
- [ ] Filter chips changent la liste correctement
- [ ] Count badge sur chaque chip à jour

## Tab Review
- [ ] Liste des tasks đến hạn hôm nay
- [ ] Chaque card affiche badge HÔM NAY ou QUÁ HẠN
- [ ] Bouton "Xem lịch đầy đủ" ouvre bottom sheet
- [ ] Empty state affiché si aucune task à réviser

## Logic Đã thuộc
- [ ] Tap "Đã thuộc" → isLearned = true
- [ ] learnedAt = DateTime.now() correct
- [ ] currentStageIndex = 0 après markLearned
- [ ] Badge task passe à "ĐANG HỌC" ou "HÔM NAY"
- [ ] Timeline mini apparaît sur la card
- [ ] Stats dashboard mis à jour

## Logic Hủy thuộc
- [ ] Tap "Hủy thuộc" → CupertinoAlertDialog apparaît
- [ ] Dialog titre clair, 2 boutons (Không / Xác nhận hủy)
- [ ] Bouton "Không" annule sans changement
- [ ] Bouton "Xác nhận hủy" → isLearned = false, learnedAt = null, currentStageIndex = -1
- [ ] Badge task revient à "CHƯA THUỘC"
- [ ] Task disparaît du tab Review si elle y était

## Bottom Sheet "Hôm nay cần ôn"
- [ ] S'ouvre depuis Home CTA card
- [ ] S'ouvre depuis tab Review (bouton Chi tiết)
- [ ] Style blur / rounded / translucent
- [ ] Handle bar visible en haut
- [ ] Bouton fermeture (xmark) fonctionne
- [ ] Chaque task item affiche: tên, ngày bắt đầu, mốc, ngày ôn
- [ ] Full timeline 1/3/7/14/30 avec ngày cụ thể
- [ ] Labels: HOÀN THÀNH / HÔM NAY / QUÁ HẠN / SẮP TỚI corrects
- [ ] Empty state si aucune task due

## GitHub Actions Workflow
- [ ] Fichier .github/workflows/ios_unsigned_ipa.yml présent
- [ ] Workflow se lance sur push main/master
- [ ] Setup Flutter stable
- [ ] flutter pub get réussit
- [ ] pod install réussit
- [ ] flutter build ios --release --no-codesign réussit
- [ ] Artifact SpacedRep_unsigned.ipa uploadé
- [ ] Build log uploadé
- [ ] Fallback xcodebuild no-sign présent
- [ ] README documente clairement les limites du unsigned build

## Points de vigilance
- [ ] Unsigned IPA ne peut PAS être installé sur iPhone sans signing
- [ ] README ne prétend PAS que l'IPA est installable directement
- [ ] CHECKLIST.md présent et complet
