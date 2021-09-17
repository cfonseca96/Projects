use Database
go

select *
from [car_info]

select distinct make --all makes look good no mistakes
from [car_info]

select distinct fuel_type -- only two fuel types gas and diesel
from [car_info]

select distinct num_of_doors --two null values  
from [car_info]

		select * --one dodge one mazda will fix this later 
		from [car_info]
		where num_of_doors is null 
		
select distinct body_style --all body types look good 
from [car_info]

select distinct [drive_wheels] -- looks good missing awd tho subaru has some of these
from [car_info]

select distinct [engine_location] --engine location looks good
from [car_info]

select distinct [wheel_base] -- wheelbase looks fine no nulls
from [car_info]
order by 1

select distinct [length] --car length looks fine no nulls
from [car_info]
order by 1

select max(length), min(length) --no outside values of car length
from [car_info]

select distinct [width] --no null values
from [car_info]

select max([width]), min([width]) -- no outside values for width
from [car_info]

select distinct [height] --no nulls 
from [car_info]

select max(height), min(height) -- no outside values for height
from [car_info]

select max(curb_weight), min(curb_weight) -- no outside values for curb weight
from [car_info]

select distinct [curb_weight] --no nulls
from [car_info]

select distinct [engine_type] --all engine types accounted for I means inline
from [car_info]

select distinct [num_of_cylinders] -- tow appeared in number of cylinders, will fix later
from [car_info]

		select *
		from [car_info]
		where num_of_cylinders = 'tow' --rotor engines dont have cylinders since its a diff type of engine 


select max(engine_size), min(engine_size) --engine sizes look within range
from [car_info]

select distinct [engine_size] --no null values
from [car_info]

select distinct [fuel_system] -- all fuel types are present
from [car_info]

select distinct [compression_ratio] --no null values
from [car_info]

select max(compression_ratio), min(compression_ratio) --compression ratio is not within range
from [car_info]

		select * --compression ratio is 70 i think its meant to be 7 wil fix later
		from [car_info]
		where compression_ratio > 23 

select max(horsepower), min(horsepower) --horsepower in range
from [car_info]

select distinct [horsepower] --no null values
from [car_info]

select max([city_mpg]), min([city_mpg]) --mpg in range 
from [car_info]

select * --no null values
from [car_info]
where city_mpg is null

select max([highway_mpg]), min(highway_mpg) --highway mpg is all within range
from [car_info]

select * --no null values found in this dataset
from car_info
where highway_mpg is null

select max([price]), min([price]) --price is not within range in this dataset
from [car_info]

		select * --these prices are all 0 which is clearly wrong lets will fix later
		from [car_info]
		where price < 5118
go

all mistakes now



select make, num_of_doors, num_of_cylinders, compression_ratio, price --all mistakes
from [car_info]
where num_of_doors is null or --one dodge one mazda
	num_of_cylinders = 'tow' or --rotor engines dont have cylinders since its a diff type of engine
	compression_ratio > 23 or --compression ratio is 70 i think its meant to be 7 
	price < 5118 --some prices lower than the minimum
go

--fixing all mistakes

update [car_info] --update doors
set num_of_doors = 'four'
where num_of_doors is null

select * -- no more null doors
from [car_info]
where num_of_doors is null 
go

update [car_info] --fixed misspelled cylinder numbers
set num_of_cylinders = 'two'
where num_of_cylinders ='tow'

select * 
from car_info
where num_of_cylinders = 'tow'
go

delete [car_info] --delete row with wrong compression number
where compression_ratio = 70

select *
from car_info
where compression_ratio = 70
go

--need to ask the sales manager for the price of these vehicles

select *
from [car_info]
where price = 0

--otherwise data is clean and ready to analyze




