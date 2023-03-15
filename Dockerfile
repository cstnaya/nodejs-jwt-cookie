# 指定基本 IMAGE
FROM node:16

# 指定此專案要在 container 的哪個路徑下執行 
# 通常不會指定 /
WORKDIR /app

# 若把目前路徑底下的東西通通複製到 Container，可以這樣寫
# COPY . /app

# 但通常不會這樣做，.gitignore 裡面指定的檔案我們都會忽略
# 例如 /node_modules 不該用複製的

# 常見步驟是:
# 1. 先複製 package.json, package-lock.json
COPY package*.json ./

# 2. 執行 npm ci 把套件下載下來
RUN npm ci

# 3. 把專案中的檔案，但不包含 .gitignore 裡的，複製到 Container
COPY . .

# run node server.js
CMD ["node", "server.js"]
