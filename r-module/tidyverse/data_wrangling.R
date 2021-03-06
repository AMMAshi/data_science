(.packages())

library(tidyverse)

penguins_madeup_wide <- tribble(
  ~name,        ~sex,     ~tap_dance, ~body_mass_1, ~body_mass_2, ~body_mass_3, 
  "Mumble",     "male",   TRUE,       4801,         5699,         5743,         
  "Gloria",     "female", FALSE,      4785,         3092,         4220,         
  "Memphis",    "male",   FALSE,      3349,         4186,         4454,         
  "Norma Jean", "female", FALSE,      4235,         3220,         4019        
)

penguins_madeup_wide
## # A tibble: 12 x 5
##    name       sex    tap_dance measurement body_mass
##    <chr>      <chr>  <lgl>     <chr>           <dbl>
##  1 Mumble     male   TRUE      1                4801
##  2 Mumble     male   TRUE      2                5699
##  3 Mumble     male   TRUE      3                5743
##  4 Gloria     female FALSE     1                4785
##  5 Gloria     female FALSE     2                3092
##  6 Gloria     female FALSE     3                4220
##  7 Memphis    male   FALSE     1                3349
##  8 Memphis    male   FALSE     2                4186
##  9 Memphis    male   FALSE     3                4454
## 10 Norma Jean female FALSE     1                4235
## 11 Norma Jean female FALSE     2                3220
## 12 Norma Jean female FALSE     3                4019

#Great visual for understanding pivot_longer and pivot_wider
#https://www.dropbox.com/s/a6o75zj443b2rv3/tidyr-longer-wider-modified.gif?dl=0

??gather
??spread

penguins_madeup_wide %>%
  pivot_longer(
    cols = starts_with("body_mass"),
    names_to = "measurement",
    values_to = "body_mass"
  )

penguins_madeup_long <- penguins_madeup_wide %>%
  pivot_longer(
    cols = starts_with("body_mass"),
    names_to = "measurement",
    names_prefix = "body_mass_",
    values_to = "body_mass"
  )
penguins_madeup_long

penguins_madeup_long %>%
  mutate(name = fct_reorder2(name, measurement, body_mass)) %>%
  ggplot(aes(x = measurement, y = body_mass,
             group = name, color = name)) +
  geom_point() +
  geom_line()

library(ggrepel)

ggplot(penguins_madeup_long, 
       aes(x = measurement, y = body_mass, group = name, color = name)) +
  geom_point() +
  geom_line() +
  guides(color = FALSE) +
  geom_label_repel(data = penguins_madeup_long %>% filter(measurement == 3),
                   aes(label = name)) + 
  labs(
    x = "Measurement",
    y = "Body mass (g)",
    title = "Body mass measurements of penguins",
    subtitle = "Simulated data",
    caption = "Do you recognize the names of these penguins? 
    See imdb.com/title/tt0366548 for a hint!"
  )

penguins_madeup_long

#Column-wise operations
#https://cran.r-project.org/web/packages/dplyr/vignettes/colwise.html

penguins_madeup_wide

penguins_madeup_wide %>%
  summarise(
    body_mass_1_avg = mean(body_mass_1),
    body_mass_2_avg = mean(body_mass_2),
    body_mass_3_avg = mean(body_mass_3)
  )

penguins_madeup_wide %>%
  summarise(across(starts_with("body_mass"),mean))

penguins_madeup_wide %>%
  summarise(
    sample_mean = across(starts_with("body_mass"), mean),
    sample_sd = across(starts_with("body_mass"), sd),
  )

penguins_madeup_wide %>%
  summarise(across(
    starts_with("body_mass"),
    list(sample_mean = mean, sample_sd = sd)
  ))

# Exercise: turn the data we just created into this table
## # A tibble: 3 x 3
##   measurement sample_mean sample_sd
##   <chr>             <dbl>     <dbl>
## 1 1                 4292.      682.
## 2 2                 4049.     1203.
## 3 3                 4609       777.

#Row-wise operations
#https://dplyr.tidyverse.org/articles/rowwise.html

penguins_madeup_wide

penguins_madeup_wide <- penguins_madeup_wide %>%
  rowwise() %>%
  mutate(body_mass_avg = mean(c_across(starts_with("body_mass"))))

penguins_madeup_wide

penguins_madeup_wide <- penguins_madeup_wide %>%
  rowwise() %>%
  mutate(body_mass_median = median(c_across(starts_with("body_mass"))))

penguins_madeup_wide
