#!/bin/bash

# Misol uchun, pastki qatorlarni tekshiring
if [ "$(zenity --question --text='Tizimni ochirishni xohlaysizmi?')" == 0 ]; then
  systemctl poweroff
else
  exit 0
fi
