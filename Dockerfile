# select base IMAGE
# FROM <image-name>:<version>
FROM node:lts-alpine

# 指定此專案要在 container 的哪個路徑下執行 
# 通常不會指定 /
WORKDIR /app

# 若把目前路徑底下的東西通通複製到 Container 的 /app，可以這樣寫
# . => 目前我的專案路徑底下所有檔案
# /app => 容器目標路徑
# COPY . /app

# 但通常不會這樣做，.gitignore 裡面指定的檔案我們都不複製
# 例如 /node_modules 不該用複製，而是用安裝

# 常見步驟是:
# 1. 先複製 package.json, package-lock.json
COPY package*.json ./

# 2. 執行 npm ci 把套件下載下來
# `--omit=dev` or `--only=production` 可以把 devDependency 裡面的套件忽略不載，通常在部署正式機階段會做這事
RUN npm ci --only=production

# 3. 把專案中的檔案，但不包含 .gitignore 裡的，複製到 Container
COPY . .

# 4. 如果需要建置專案 (build)
# RUN npm run build

# 5. 指定操作 user，node image 系統內建 node 這個 user
USER node

# 指定 IMAGE 建置成功後要執行的 launch 指令
# 只能指定一次，詳細看此: https://stackoverflow.com/a/37462208

# run node server.js
CMD ["node", "server.js"]

EXPOSE 3000