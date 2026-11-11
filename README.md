# Presente

> Um toque por dia. Uma família em paz.

Aplicativo mobile em Flutter para apoiar idosos que moram sozinhos, desenvolvido para a Global Solution FIAP 2026.2 (3º ano de Sistemas de Informação).

## Desenvolvedores

| Nome completo | RM |
|---|---|
| Gabriel Araujo da Silva Brito | 558802 |
| Arthur Brugnerotto Cerqueira | 558836 |
| Giovana Santos Silva | 558873 |

## Tema da Global Solution

Desafio **CitizenTech**: criar uma tecnologia a partir de uma necessidade real das pessoas.

Tema escolhido: **tecnologia de apoio a idosos, com autonomia e segurança para quem mora sozinho.**

ODS relacionados:

- **ODS 3** - Saúde e bem-estar
- **ODS 10** - Redução das desigualdades
- **ODS 11** - Cidades e comunidades sustentáveis

## O problema

O Censo 2022 do IBGE contou milhões de idosos morando sozinhos no Brasil. Se um deles passa mal ou cai, pode ficar horas ou dias sem ajuda, e a família vive com a dúvida "será que está tudo bem?". As soluções existentes costumam ser caras (pulseiras, teleassistência) ou complicadas para quem tem pouca familiaridade com tecnologia.

## Descrição da solução

O Presente é um aplicativo com interface muito acessível (letras grandes, poucas opções por tela, linguagem simples). Todo dia o idoso toca em um botão gigante, "Estou bem", e a família fica tranquila.

Funcionalidades desta versão:

- Botão **Estou bem**, com registro de data e hora.
- Botão **Mais tarde**, para adiar o aviso do dia.
- Botão **Preciso de ajuda**: contagem de 5 segundos (com opção de cancelar), aviso aos contatos e atalho para ligar ao **192 (SAMU)**.
- **Contatos**: ligar com um toque e marcar quem é avisado primeiro (favoritos).
- **Clima e cuidados**: previsão de 7 dias para dez capitais, com dicas de cuidado (calor, chuva, frio) e filtros.
- **Histórico** dos últimos 30 dias, com filtro por tipo de registro.

Nesta versão, o aviso à família é simulado: o app registra o evento no aparelho e mostra quem seria avisado. O envio real (notificação para a família, painel remoto) faz parte da evolução da solução.

## Fluxo de telas

```
Splash
  |-- (já marcou "Não mostrar novamente") --> Início
  '-- (primeira vez) --> Introdução (3 páginas) --> Início

Início (navegação inferior)
  |-- Início ----------> Preciso de ajuda (contagem, 192, ligar para contato)
  |-- Contatos
  |-- Clima -----------> Detalhe do dia (parâmetro: cidade e previsão)
  '-- Histórico
```

Telas principais: Início, Contatos, Clima e cuidados, Histórico, Preciso de ajuda e Detalhe do dia.

## Prints das telas

Adicione as imagens na pasta `docs/prints/` e mantenha os nomes abaixo.

| Splash | Introdução | Início |
|---|---|---|
| ![Splash](docs/prints/01-splash.png) | ![Introdução](docs/prints/02-introducao.png) | ![Início](docs/prints/03-inicio.png) |

| Preciso de ajuda | Contatos | Clima |
|---|---|---|
| ![Ajuda](docs/prints/04-ajuda.png) | ![Contatos](docs/prints/05-contatos.png) | ![Clima](docs/prints/06-clima.png) |

| Detalhe do dia | Histórico | Erro de rede |
|---|---|---|
| ![Detalhe](docs/prints/07-detalhe.png) | ![Histórico](docs/prints/08-historico.png) | ![Erro](docs/prints/09-erro.png) |

## API utilizada

**Open-Meteo** (API pública, gratuita e sem chave): <https://open-meteo.com/>

Endpoint consumido:

```
GET https://api.open-meteo.com/v1/forecast
    ?latitude=...&longitude=...
    &daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_sum
    &timezone=auto&forecast_days=7
```

O JSON é convertido em objetos Dart (`DailyForecast`) e exibido na tela de clima. A tela trata os quatro estados (inicial, carregamento, sucesso e erro), mostra mensagem amigável em caso de falha e oferece o botão "Tentar novamente".

## Arquitetura

```
lib/
  main.dart
  app/        rotas nomeadas, gerador de rotas e tema
  models/     DailyForecast, City, Contact, CheckIn, filtros e estado de carregamento
  services/   WeatherService (http), StorageService (SharedPreferences),
              CheckInService, ContactService, PhoneService, CareAdvisor
  utils/      formatadores de data, hora e telefone
  widgets/    componentes reutilizáveis (BigButton, StatusCard, ForecastTile,
              ErrorState, TodayWeatherCard, WeatherIcon...)
  screens/    telas do aplicativo
```

Decisões:

- **Separação de responsabilidades:** as telas apenas exibem dados e chamam serviços. Acesso à API, persistência e regras (níveis de cuidado, filtros, ordenação de contatos) ficam em `services/` e `models/`.
- **Gerenciamento de estado:** `setState` em `StatefulWidget`, com `StatelessWidget` para componentes sem estado.
- **Navegação:** `Navigator` com rotas nomeadas. Os parâmetros são passados por `arguments` (`HelpArguments` e `ForecastDetailArguments`).
- **Persistência local:** `SharedPreferences` guarda a preferência da introdução, os contatos, o histórico de registros e a cidade escolhida.
- **Widgets reutilizáveis:** botões grandes, cards de status, item de previsão e estado de erro são usados em várias telas.

## Requisitos da atividade

| Requisito | Onde está |
|---|---|
| Splash com logo, transição automática e checagem com SharedPreferences | `screens/splash_screen.dart` |
| Introdução com 3 páginas, voltar/avançar e "Não mostrar novamente" | `screens/onboarding_screen.dart` |
| 4+ telas, navegação e parâmetros | `app/app_router.dart`, `screens/` |
| Consumo de WebService com `http`, models e 4 estados | `services/weather_service.dart`, `screens/weather_screen.dart` |
| Componentes (Column, Row, Card, ListView, Scaffold, AppBar, botões, Icon, Image.asset) | `screens/`, `widgets/` |
| 3+ interações (lista para detalhe, filtros, favoritar, registrar "Estou bem") | `weather_screen`, `history_screen`, `contacts_screen`, `home_screen` |
| Organização, `setState` e widgets reutilizáveis | estrutura de `lib/` |

## Como executar

Pré-requisito: Flutter SDK instalado.

```bash
flutter create --project-name presente --org br.com.fiap .
flutter pub get
flutter analyze
flutter test
flutter run
```

Para rodar no Chrome com a preferência da introdução e o histórico preservados entre execuções, fixe a porta:

```bash
flutter run -d chrome --web-port 5000
```

No navegador, o botão de ligar mostra uma janela com o número, porque o Chrome não disca sozinho. Em um celular, ele abre o discador do aparelho. Em telas largas, o app é centralizado em uma coluna de até 520 px, como no celular.

O comando `flutter create .` gera apenas as pastas de plataforma (android, ios, etc.) e mantém os arquivos do projeto.

Para gerar o app em modo release no Android, confirme que o arquivo `android/app/src/main/AndroidManifest.xml` contém a permissão de internet:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

As ligações usam o discador do aparelho. No emulador, a chamada pode não abrir; teste em um celular.

## Vídeo pitch

Link do vídeo (YouTube, público): _adicionar aqui_
