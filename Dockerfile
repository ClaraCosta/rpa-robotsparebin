FROM python:3.10-slim

# Instalação de dependências básicas e do Google Chrome
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    curl \
    gnupg \
    xvfb \
    x11vnc \
    xterm \
    libx11-dev \
    libnss3 \
    libatk-bridge2.0-0 \
    libgbm-dev \
    libgtk-3-0 \
    libxshmfence-dev \
    libasound2 \
    libpangocairo-1.0-0 \
    libxss1 \
    && rm -rf /var/lib/apt/lists/*

# Instalação do Pipenv
RUN pip install pipenv

RUN pip install rpaframework==28.6.2


RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Baixar e instalar a versão correspondente do ChromeDriver
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmour -o /usr/share/keyrings/chrome-keyring.gpg \
    && sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list' \
    && apt-get update && apt-get install -y google-chrome-stable \
    && CHROME_VERSION=$(google-chrome --version | grep -oP "\d+\.\d+\.\d+\.\d+") \
    && echo "Chrome version being downloaded: $CHROME_VERSION" \
    && wget "https://storage.googleapis.com/chrome-for-testing-public/$CHROME_VERSION/linux64/chromedriver-linux64.zip" -O chromedriver-linux64.zip \
    && unzip chromedriver-linux64.zip -d /opt/chromedriver \
    && chmod +x /opt/chromedriver/chromedriver-linux64/chromedriver \
    && ln -s /opt/chromedriver/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver

RUN curl -fsSL https://downloads.robocorp.com/rcc/releases/latest/linux64/rcc -o /usr/local/bin/rcc \
    && chmod +x /usr/local/bin/rcc \
    && rcc config diagnostics

    
# Copiar a estrutura do projeto para o container
COPY . /app
WORKDIR /app

# Configuração do Pipenv
ENV PIPENV_IGNORE_VIRTUALENVS=1
ENV PIPENV_VENV_IN_PROJECT=1

# Porta exposta para VNC, caso necessário
EXPOSE 5900

# Volume para sincronização de arquivos com o host
VOLUME ["/app"]

# Comando padrão para manter o container ativo
CMD ["tail", "-f", "/dev/null"]