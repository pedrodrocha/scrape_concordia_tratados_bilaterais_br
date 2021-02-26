# 0) Packages
library(RSelenium)
library(magrittr)
library(rstudioapi)
library(rvest)
library(purrr)
library(usethis)
library(stringr)
library(tibble)
library(dplyr)
source('R/00_utils.R')

# 1) Load url_data
load('raw_data/url_acordos.RData') # Os acordos numero 4194 e 3871 estao com o link quebrado em 25-02-2021


# 2) Start Selenium WebDriver

terminalExecute('docker run --name r_selenium -d -p 4445:4444  selenium/standalone-chrome')

## Create Selenium Driver
remDr <- remoteDriver(
  remoteServerAddr = 'localhost',
  port = 4445L,
  browserName = "chrome"
)

## Open Headless browser
remDr$open(silent =FALSE)


# 3) Colect Data
dat <- tibble()
for (i in seq_along(url_acordos)) {
  ## Status
  ui_info(paste0('Progress: ',i, ' of ',length(url_acordos)))

  ## Navigate to rul
  remDr$navigate(url_acordos[i])

  ## Loading page
  wait_load(using = 'css selector',value = 'h3')

  ## Parse page
  read_html(remDr$getPageSource()[[1]]) -> parsed_url

  ## Build dataset
  dat <- build_data(parsed_url = parsed_url) %>%
    bind_rows(dat,.)


}

# 4) Save output

## csv
readr::write_csv(dat, 'data/bilaterais_brasil.csv')

## RData
save(dat, file = here::here('data/bilaterais_brasil.Rdata'))

## Excel
writexl::write_xlsx(dat, 'data/bilaterais_brasil.xlsx')

# 5) End

## Closing Selenium driver
remDr$close()

## Stoping and removing docker container
terminalExecute('docker stop r_selenium')
terminalExecute('docker container rm r_selenium')
