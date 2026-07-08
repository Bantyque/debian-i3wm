#!/bin/bash

# Запускаем всё последовательно с небольшими паузами
# чтобы каждое приложение успело открыться на нужном workspace

# Workspace 1 — браузер
i3-msg 'workspace 1'
firefox &
sleep 1

# Workspace 3 — файловый менеджер
i3-msg 'workspace 3'
# замени на свой FM если другой
thunar &
sleep 0.5

# Workspace 2 — документ
i3-msg 'workspace 2'
libreoffice --writer ~/Документы/"намба ван посты.docx" &

# Возвращаемся на workspace 1
sleep 1
i3-msg 'workspace 1'
