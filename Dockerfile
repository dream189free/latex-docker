# fix version
FROM ghcr.io/xu-cheng/texlive-full:latest

LABEL org.opencontainers.image.title="Docker Image of TeXLive with dreamclass Support" \
  org.opencontainers.image.authors="Cheng Xu <copyright@xuc.me>, HermitSun <syl1887415157@126.com>, Tianyi Liu <tyi.liu@outlook.com>" \
  org.opencontainers.image.source="https://github.com/dream189free/latex-docker" \
  org.opencontainers.image.licenses="MIT"

# install tools
RUN apk add p7zip py3-pip \
  && pip3 install lastversion

# get FZ fonts
# fonts from https://github.com/dream189free/dreamclass
# ignore files in .dockerignore
COPY . /
RUN cp /opt/texlive/texdir/texmf-var/fonts/conf/texlive-fontconfig.conf /etc/fonts/conf.d/09-texlive.conf \
    && mv /dreamclass/ /usr/share/fonts/

# get sarasa gothic
RUN wget `lastversion be5invis/Sarasa-Gothic --assets --filter "sarasa-gothic-ttf-[^u]"` -O /tmp/sarasa-gothic.7z \
  && 7z x /tmp/sarasa.7z -o/usr/share/fonts/dreamclass \
  && rm -f /tmp/sarasa.7z

# get source han
RUN wget `lastversion adobe-fonts/source-han-sans --assets --filter "SourceHanSansSC.zip"` -O /tmp/source-han-sans.zip \
  && unzip /tmp/source-han-sans.zip -d /usr/share/fonts/dreamclass \
  && rm -f /tmp/source-han-sans.zip

# get source serif
RUN wget `lastversion adobe-fonts/source-han-serif --assets --filter "SourceHanSerifSC.zip"` -O /tmp/source-han-serif.zip \
  && unzip /tmp/source-han-serif.zip -d /usr/share/fonts/dreamclass \
  && rm -f /tmp/source-han-serif.zip

# download dreamclass && rebuild font cache
RUN mkdir -p /root/texmf/tex/latex/dreamclass/ \
    && cd /root/texmf/tex/latex/dreamclass/ \
    && wget https://raw.githubusercontent.com/dream189free/dreamclass/master/dreamClass.cls \
    && texhash /root/texmf/ \
    && fc-cache -fv
