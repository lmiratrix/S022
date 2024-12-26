##
## Exploring Tenn Star data
##

library( tidyverse )
library( lme4 )
library( lmerTest ) ## only need this if you want p-values from your lmer models

rm(list = ls())


#### Load the data and look at it ####


stud <- read.csv('tenn_stud_dat.csv') ## student-level data
teach <- read.csv('tenn_teach_dat.csv') ## teacher-level data

dat <- merge(stud, teach) ## merge the datasets. Automatically merges by clid, class id, the only variable in common

dat <- na.omit(dat) ## for simplicity, we'll delete everyone missing any variables

names(dat)
nrow( dat )

head(dat$tmathssk) ## math scores after kindergarten, the primary outcome

dat$small_class <- dat$cltypek == 'small class' ## create an indicator for being in a small class

head( dat )

qplot( dat$tmathssk )

length(unique(dat$clid)) ## 196 classes (as opposed to
nrow(dat) ## 3219 students)



##### Fitting some WRONG models to estimate impact ####

## We would want to fix this with cluster-robust SEs!!!

t.test(dat$tmathssk ~ dat$small_class) ## a first pass using only a t-test

mod <- lm(tmathssk ~ small_class, data = dat) ## another way to get the same result (more or less)
summary(mod)



table(dat$ssex) ## we might gain precision by adjusting for student sex,
table(dat$srace) ## race,
table(dat$sbirthq) ## and age (birth quartile)
table(dat$totexpk) ## we might also add class-level covariates, like teacher experience


mod_full_cov <- lm(tmathssk ~ ssex + srace + totexpk + small_class, data = dat)
summary(mod_full_cov)



#### Alternate approach: fixed effects for class  ####

mod_fe <- lm(tmathssk ~ 0  + ssex + srace + totexpk + small_class + as.factor(clid), 
             data = dat)
summary(mod_fe) ## except the fixed effects are collinear with all class-level variables

# Note: Including fixed effects would only work for us if we had randomization or variation
# within cluster




#### Alternate approach: multilevel modeling  ####


## A classic: the random intercept approach
mod_re <- lmer(tmathssk ~ ssex + srace + totexpk + small_class + (1|clid), 
               data = dat)
summary(mod_re)


## but to be more realistic we might want random coefficients for some of the
## covariates as well
mod_re_full <- lmer(tmathssk ~ ssex + srace + totexpk + small_class + (ssex + srace|clid), 
                    data = dat)
summary(mod_re_full)

## that took a lot longer! And it didn't converge for me! Also, it makes a lot
## of assumptions such as

## 1) homoscedasticity of residuals
## 2) random effects are normally distributed
## 3) treatment effect is constant across teachers
## which the cluster-robust errors don't.



#### Looking at logistic regression (GLMs) ####

## NOTE: This is moving into "fake analysis for illustration" territory.

# make a binary "high score" variable
dat$high_math <- dat$tmathssk >= median(dat$tmathssk)

## we can do the same thing with a GLM
mod <- glm(high_math ~ small_class, data = dat, family = 'binomial')

summary(mod) ## now you see the TE

# But these SEs are WRONG---need clustering to fix.

# add a class-by-experience interaction
mod <- lm(tmathssk ~ small_class * totexpk, data = dat)
summary(mod)
# (Still wrong SEs)
