### Automount USB device in MOUNTDIR (/home/USERNAME/TARGEDDIR/) folder<br>
### Автоматическое монтирование usb устройства в домашнюю папку MOUNTDIR (/home/USERNAME/TARGEDDIR/)<br>
### version 0.1<br>
### Папка - точка монтирования создается с названием label устройства в нижнем регистре.<br>

Порядок действий для добавления функции автомонтирования:<br>
<br>
1. Добавить новые правила в udev<br>
  1.1 Скопировать файл /etc/udev/rules.d/local.rules<br>
  1.2 Перезапустить правила udev командой: sudo udevadm control --reload-rules<br>
2. Добавить файлы bash скриптов в /lib/udev/<br>
  2.1 Скопировать /lib/udev/udev-automounter.sh<br>
  2.2 Скопировать /lib/udev/udev-auto-mount.sh<br>
  2.3 Скопировать /lib/udev/udev-unmounter.sh<br>
  2.4 Для каждого файла 2.1, 2.2, 2.3 дать права на возможность исполнения: sudo chmod +x <имя файла bash скрипта><br>
<br>
<br>
##Назначение файлов:<br>
<br>
/etc/udev/rules.d/local.rules - правила для udev, по которым он будет запускать bash скрипты при добавление/удаление устройства<br>
/lib/udev/udev-automounter.sh - вызывается при добавление устройства. запускает скрипт монтирования /lib/udev/udev-auto-mount.sh<br>
/lib/udev/udev-auto-mount.sh  - создает точку (папку) для монтирования (если еще не существует) и выполняет монтирование<br>
/lib/udev/udev-unmounter.sh   - отмонтирование устройства от точки монтировния
<br>
<br>
##Приложение:<br>
http://superuser.com/questions/53978/automatically-mount-external-drives-to-media-label-on-boot-without-a-user-logge<br>
http://superuser.com/questions/31917/is-there-a-way-to-show-notification-from-bash-script-in-ubuntu<br>
http://askubuntu.com/questions/297412/how-do-i-make-udev-rules-work<br>
http://vishnulinux.wordpress.com/2012/03/18/device-is-already-mounted-or-mountpoint-is-busy/<br>
http://unix.stackexchange.com/questions/44454/how-to-mount-removable-media-in-media-label-automatically-when-inserted-with<br>
http://ubuntuforums.org/showthread.php?t=1812529<br>