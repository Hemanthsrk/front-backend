
# Stage 1: Build Frontend
FROM node:18-alpine 
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ .
RUN npm run build

# Stage 2: Setup Backend
FROM node:18-alpine 
WORKDIR /app/backend
COPY backend/package*.json ./
RUN npm install
COPY backend/ .

# Stage 3: Setup Final Image
FROM node:18-alpine
WORKDIR /app
COPY --from=backend-build /app/backend /app/backend
COPY --from=frontend-build /app/frontend/build /app/backend/public

WORKDIR /app/backend
EXPOSE 5000

CMD ["npm", "start"]

