#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["frontend/Server/frontend.Server.csproj", "frontend/Server/"]
COPY ["frontend/Client/frontend.Client.csproj", "frontend/Client/"]
COPY ["frontend/Shared/frontend.Shared.csproj", "frontend/Shared/"]
RUN dotnet restore "frontend/Server/frontend.Server.csproj"
COPY . .
WORKDIR "/src/frontend/Server"
RUN dotnet build "frontend.Server.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "frontend.Server.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "frontend.Server.dll"]