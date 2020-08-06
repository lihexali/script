cat 1.txt | xargs -n 1 -I {} wget -P {} http://scsgj.egret-labs.org/cs/static/resource/assets/textures/effect/{}/E.png
