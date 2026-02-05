FROM node:22.13.0

RUN useradd -ms /bin/bash appuser

RUN mkdir -p /app && chown -R appuser:appuser /app

WORKDIR /app

COPY --chown=appuser:appuser . .

USER appuser

#RUN npm i yarn
#RUN yarn global add @angular/cli@latest
RUN rm -rf node_modules
RUN yarn && yarn add moment && yarn add vis-util && npm run build --prod --build-optimizer
RUN npm run compress:brotli
#RUN npm run compress:gzip

WORKDIR /app/dist

COPY --chown=appuser:appuser assets/SPV/client-assets/dist www/en/assets

RUN npm install --production

EXPOSE 3004
CMD ["npm", "run", "serve:prod"]
