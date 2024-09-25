FROM mcr.microsoft.com/playwright:v1.39.0-focal

COPY . /app
WORKDIR /app
RUN npm install
RUN npx playwright install-deps
RUN npx playwright install
ENTRYPOINT [ "npm", "run", "test" ]