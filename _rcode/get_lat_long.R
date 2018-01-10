# To plot the location of each farm, we need the latitude and longitude of each farm's address.
# Probably easier to do this up front, rather than as we try to build the map. Should look to see
# if a yml file already has lat/long data. If geocodeAddress fails with a street address, we return
# the coordinates for their zipcode.

#install.packages("RJSONIO")
library(RJSONIO)


geocodeAdddress <- function(address) {
  url <- "http://maps.google.com/maps/api/geocode/json?address="
  url <- URLencode(paste(url, address, "&sensor=false", sep = ""))
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

run_address <- function(file){
	yaml <- readLines(file)
	if(!sum(grepl("^lat:", yaml))){
		print(file)
		street <- paste0("'", gsub("street: ", "", yaml[grep("street: ", yaml)]), "'")
		city <- gsub("city: ", "", yaml[grep("city: ", yaml)])
		state <- gsub("state: ", "", yaml[grep("state: ", yaml)])
		zip <- gsub("zip: ", "", yaml[grep("zip: ", yaml)])

		address <- paste(street, city, state, zip, sep=', ')
		lat_long <- geocodeAdddress(address)

		if(is.na(lat_long['lat'])){
			address <- zip
			lat_long <- geocodeAdddress(address)
			warning(paste0("Could not find coordinates for: ", file, ". Using zipcode instead."))
		}

		yaml[length(yaml)] <- paste0("lat: ", lat_long["lat"])
		yaml[length(yaml)+1] <- paste0("long: ", lat_long["long"])
		yaml[length(yaml)+1] <- '---'

		write(yaml, file=file)
	}
}

yml_files <- list.files('_breeders', full.names=T, pattern="*.yml")
sapply(yml_files, run_address)
print("Be sure to check to make sure there are no addresses with 'SR' in them")
