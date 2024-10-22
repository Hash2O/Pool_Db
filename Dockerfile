# Étape 1 : Construction de l'application
# Utilisation d'une image Elixir officielle pour builder l'application
FROM elixir:1.15-alpine AS build-stage

# Installer les dépendances système nécessaires
RUN apk add --no-cache build-base git nodejs npm python3 postgresql-client

# Configurer l'environnement de travail
WORKDIR /app

# Installer Hex et Rebar (les gestionnaires de dépendances pour Elixir)
RUN mix local.hex --force && \
    mix local.rebar --force

# Copier les fichiers de configuration de dépendances
COPY mix.exs mix.lock ./

# Installer les dépendances Elixir et Phoenix
RUN mix deps.get

# Copier les fichiers de l'application
COPY . .

# Installer les dépendances JS et builder les assets (si l'application utilise des assets frontend)
RUN npm install --prefix ./assets && \
    npm run deploy --prefix ./assets

# Compiler l'application Phoenix
RUN mix phx.digest && mix compile

# Étape 2 : Préparer l'image pour exécuter l'application
FROM elixir:1.15-alpine AS production-stage

# Installer les dépendances système
RUN apk add --no-cache postgresql-client

# Configurer l'environnement de travail
WORKDIR /app

# Copier les fichiers compilés et les assets depuis l'étape de build
COPY --from=build-stage /app/_build /app/_build
COPY --from=build-stage /app/deps /app/deps
COPY --from=build-stage /app/priv /app/priv
COPY --from=build-stage /app/config /app/config
COPY --from=build-stage /app/lib /app/lib

# Exposer le port 4000 pour l'application Phoenix
EXPOSE 4000

# Démarrer l'application Phoenix en production
CMD ["mix", "phx.server"]
