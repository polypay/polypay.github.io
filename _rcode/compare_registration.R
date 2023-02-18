library(tidyverse)
library(readxl)
library(yaml)
library(RJSONIO)

align_yaml <- function(x){
	tibble(
		member_id = ifelse(is.null(x$member_id), NA, x$member_id),
		owner = ifelse(is.null(x$owner), NA, x$owner),
		farm_name = ifelse(is.null(x$farm_name), NA, x$farm_name),
		title = ifelse(is.null(x$title), NA, x$title),
		street = ifelse(is.null(x$street), NA, x$street),
		city = ifelse(is.null(x$city), NA, x$city),
		state = ifelse(is.null(x$state), NA, x$state),
		zip = ifelse(is.null(x$zip), NA, x$zip),
		phone1 = ifelse(is.null(x$phone1), NA, x$phone1),
		phone2 = ifelse(is.null(x$phone2), NA, x$phone2),
		email = ifelse(is.null(x$email), NA, x$email),
		website = ifelse(is.null(x$website), NA, x$website),
		lat = ifelse(is.null(x$lat), NA, x$lat),
		long = ifelse(is.null(x$long), NA, x$long),
		status = ifelse(is.null(x$status), NA, x$status)
	)
}

get_lat_long <- function(street, city, state, zip){

	address <- paste(street, city, state, zip, sep=', ')
	print(address)
	lat_long <- geocodeAdddress(address)

	if(is.na(lat_long['lat'])){
		warning(paste0("Could not find coordinates for: ", address, ". Using zipcode instead."))
		address <- zip
		lat_long <- geocodeAdddress(address)
	}
	as_tibble(as.list(lat_long))
}



geocodeAdddress <- function(address) {
  url <- "https://maps.google.com/maps/api/geocode/json?address="
  url <- URLencode(paste(url, address, "&key=AIzaSyAzSWbWcsilEiXY1UpaRJcW3cPd38nCCOo&sensor=false", sep = ""))
  x <- fromJSON(url, simplify = FALSE)
  if (x$status == "OK") {
    out <- c(lat=x$results[[1]]$geometry$location$lat,
             long=x$results[[1]]$geometry$location$lng)
  } else {
    out <- NA
  }
  Sys.sleep(0.2)  # API only allows 5 requests per second
	out
}


directory <- list.files(path = "assets/xlsx",
												pattern = "directory-20*",
												full.names = TRUE) %>%
	tail(n = 1)

exclude_columns <- c("Active/Inactive", "Dues Year Paid", "First Names", "Last Name", "Fax Number")

xlsx_directory <- read_xlsx(directory) %>%
	mutate(owner = paste(`First Names`, `Last Name`)) %>%
	rename(
					member_id = "Member #",
					farm_name = `Farm Name`,
					street = `Street Address`,
					city = City,
					state = State,
					zip = `Postal Code`,
					phone1 = `Phone #1`,
					phone2 = `Phone #2`,
					email = `E-Mail Address`,
					website = `Web Site`
				) %>%
	mutate(street=str_replace(street, ",$", "")) %>%
	mutate(street=str_replace(street, "\\.$", "")) %>%
	mutate(street=str_replace(street, "Street", "St")) %>%
	mutate(street=str_replace(street, "St\\.", "St")) %>%
	mutate(street=str_replace(street, "Road", "Rd")) %>%
	mutate(street=str_replace(street, " CR ", " County Road ")) %>%
	select(-all_of(exclude_columns)) %>%
	select(member_id, owner, everything()) %>%
	filter(!is.na(member_id))

print("through xlsx_directory")


yaml_directory <- list.files(path="_breeders", pattern="yml", full.names=TRUE) %>%
	map_dfr(., ~read_yaml(.x) %>% align_yaml())

print("through yaml_directory")


update_yaml_active <- left_join(xlsx_directory, yaml_directory, by="member_id") %>%
	mutate(
		owner.y = ifelse(owner.x != "NA NA", owner.x, owner.y),
		farm_name.y = ifelse(!is.na(farm_name.x), farm_name.x, farm_name.y),
		street.y = ifelse(!is.na(street.x), street.x, street.y),
		city.y = ifelse(!is.na(city.x), city.x, city.y),
		state.y = ifelse(!is.na(state.x), state.x, state.y),
		zip.y = ifelse(!is.na(zip.x), zip.x, zip.y),
		phone1.y = ifelse(!is.na(phone1.x), phone1.x, phone1.y),
		phone2.y = ifelse(!is.na(phone2.x), phone2.x, phone2.y),
		email.y = ifelse(!is.na(email.x), email.x, email.y),
		website.y = ifelse(!is.na(website.x), website.x, website.y),
		status = "active"
	) %>%
	select(member_id, ends_with(".y"), status, title) %>%
	rename_all(~str_replace(., "\\.y", "")) %>%
	nest(data = c(owner, farm_name, street, city, state, zip, phone1, phone2, email, website, status, title)) %>%
	mutate(lat_long = map(data, ~get_lat_long(.x$street, .x$city, .x$state, .x$zip))) %>%
	unnest(c(data, lat_long))

print("through update_yaml_active")


update_yaml_inactive <- anti_join(yaml_directory, xlsx_directory, by="member_id") %>%
	mutate(status = "inactive")

print("through update_yaml_inactive")

# need to...
#	* output new yml files to _breeders

rbind(update_yaml_active, update_yaml_inactive) %>%
	mutate(member_id = as.integer(member_id),
				zip = as.integer(zip),
				index = 1:nrow(.)) %>%
	nest(data = c(member_id, owner, farm_name, street, city, state, zip, phone1, phone2, email, website, status, title, lat, long)) %>%
	mutate(write = map(data,
										~select_if(., ~!all(is.na(.))) %>%
											as.yaml(.) %>%
											paste0("---\n", ., "---", collapse="") %>%
											write(., file=paste0("_breeders/", .x$member_id, ".yml"))
										)
				)

# do a git diff on _breeders after running to double check things
