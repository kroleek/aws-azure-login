FROM node:14-slim as build

WORKDIR /app
COPY . .
RUN yarn install && yarn test && yarn build

FROM node:14-slim

LABEL repo="https://github.com/kroleek/aws-azure-login"
LABEL maintainer="krolik.cz@gmail.com"

# Install Puppeteer dependencies: https://github.com/GoogleChrome/puppeteer/blob/master/docs/troubleshooting.md#chrome-headless-doesnt-launch
RUN apt-get update \
   && apt-get install -y \
   gconf-service \
   libasound2 \
   libatk1.0-0 \
   libc6 \
   libcairo2 \
   libcups2 \
   libdbus-1-3 \
   libexpat1 \
   libfontconfig1 \
   libgcc1 \
   libgconf-2-4 \
   libgdk-pixbuf2.0-0 \
   libglib2.0-0 \
   libgtk-3-0 \
   libnspr4 \
   libpango-1.0-0 \
   libpangocairo-1.0-0 \
   libstdc++6 \
   libx11-6 \
   libx11-xcb1 \
   libxcb1 \
   libxcomposite1 \
   libxcursor1 \
   libxdamage1 \
   libxext6 \
   libxfixes3 \
   libxi6 \
   libxrandr2 \
   libxrender1 \
   libxss1 \
   libxtst6 \
   ca-certificates \
   fonts-liberation \
   libappindicator1 \
   libnss3 \
   lsb-release \
   xdg-utils \
   wget

COPY package.json yarn.lock /aws-azure-login/

RUN cd /aws-azure-login \
   && yarn install --production

COPY --from=build  /app/lib /aws-azure-login/lib

ENTRYPOINT ["node", "/aws-azure-login/lib", "--no-sandbox"]
