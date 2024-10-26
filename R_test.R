# This example originates from here -> https://www.geeksforgeeks.org/dummy-variables-in-r-programming/

# Create a dataframe
df <- data.frame(gender = c("m", "f", "m"),
				age = c(19, 20, 20),
				city = c("Delhi", "Mumbai", 
								"Delhi"))

# Print original dataset
print(df)

# Create dummy variable
df$gender_m <- ifelse(df$gender == "m", 1, 0)
df$gender_f <- ifelse(df$gender == "f", 1, 0)

# Print resultant
print(df)

