#
# This script walks through a common type of data prep process.
#
# If you have an excel file with merged cells and lots of tables in a big ugly
# mass, then it can be hard to get those data "tidy".  One way forward is to
# first save the excel file as a CSV file, which breaks all the merged cells.
# The content of the merged cell will usually show up in the leftmost cell,
# which will give you a column of data that is a mix of table headers and table
# content.
#
# At this point, you read the ugly table into R and start identifying which
# tables start and stop where.  You can then slice out the relevant rows, and
# reformat those to get a final table that you could use.
#
# This script does the latter step, working with a sample csv file.

library( tidyverse )
dat = read_csv( "sample_ugly_data.csv", col_names = FALSE)

names(dat)

dat

dat = filter( dat, !is.na( dat$X1 ) )

which( str_detect( dat$X3, "junk word" ) )
dat = filter( dat, is.na( X3 ) | !str_detect( X3, "junk word" ) )
dat


# Locate the rows that start a table, somehow.
#
table_rows = which( str_detect( dat$X1, "Table" ) )
table_rows
dat$X1[ table_rows ]

start = table_rows[[2]] + 1
stop = table_rows[[3]] - 1
subdat = dat[ start:stop, ]
subdat

# Note: You might also detect specific rows via targeted searching.  E.g.,:
start_row = which( str_detect( dat$X1, "Alpha" ) )
start_row


# This will copy over the region names into a new "region" variable.  We know a
# region name when the X2 data are missing (table header rows often do not have
# data in other cells in that row).
subdat = mutate( subdat,
                 region = ifelse( is.na( X2 ), X1, NA ) )
subdat

# This propogates the regions to all rows.
subdat = fill( subdat, region )
subdat

# Now we drop the region header rows since we have a new column of that variable!
subdat = filter( subdat, !is.na( X2 ) )
subdat

# We next start dropping empty columns.  Any column with a lot of missing data
# will be considered junk.  This counts the number of NAs in each column.
missings = apply( is.na( subdat ), 2, sum )
missings

# This keeps only those columns with fewer than 10 missing values.
subdat = subdat[ , missings < 10 ]
subdat


# We now name our columns by pulling off the first row that has the names.  We
# have to put our hand-built rowname back in, and then we drop the row and set
# our column names!
names = as.character( subdat[ 1, ] )
names
names[ length(names) ] = "region"
names
names( subdat ) = names

subdat = subdat[ -1, ]
subdat


##### second table, just like above  #####

# One might imagine making a function to do all this stuff...

start = table_rows[[3]] + 1
stop = nrow(dat)
subdat2 = dat[ start:stop, ]
subdat2

subdat2 = mutate( subdat2,
                 region = ifelse( is.na( X2 ), X1, NA ) )
subdat2 = fill( subdat2, region )
subdat2 = filter( subdat2, !is.na( X2 ) )
subdat2

missings = apply( is.na( subdat2 ), 2, sum )
missings

subdat2 = subdat2[ , missings < 10 ]
subdat2


names = as.character( subdat2[ 1, ] )
names
names[ length(names) ] = "region"
names
names( subdat2 ) = names

subdat2 = subdat2[ -1, ]
subdat2


#### Merge our two tables #####

# We merge by both region and location since we have duplicate location names
# within different regions.
final_dat = left_join( subdat, subdat2, by=c("region", "Location") )
final_dat

final_dat = relocate( final_dat, region )

# We finally convert our numeric columns to numbers.
final_dat = mutate( final_dat,
                    Grade = parse_number( Grade ),
                    Size = parse_number( Size ) )

final_dat

# Save your file and use the cleaned file for all your actual analysis!
write_csv( final_dat, file = "cleaned_data.csv" )


