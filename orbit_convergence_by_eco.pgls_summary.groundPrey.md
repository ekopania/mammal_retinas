# Based on Brownian motion model, orbit convergence is associated with arboreal foraging
## Arboreal hypothesis, nlme BM
```
Generalized least squares fit by REML
  Model: oc ~ forstrat
  Data: smallHerb_df
       AIC      BIC    logLik
  634.1062 641.3263 -314.0531

Correlation Structure: corBrownian
 Formula: ~spp
 Parameter estimate(s):
numeric(0)

Coefficients:
               Value Std.Error  t-value p-value
(Intercept) 34.80910  8.350056 4.168727  0.0001
forstratG    7.58499  2.862579 2.649704  0.0097

 Correlation:
          (Intr)
forstratG -0.212

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.0132083 -0.3365209  0.2753539  1.0881700  2.9547309

Residual standard error: 22.10215
Degrees of freedom: 84 total; 82 residual
```

# Based on Pagel's lambda model, orbit convergence is not associated with arboreal foraging
## Arboreal hypothesis, nlme Pagel
```

Generalized least squares fit by REML
  Model: oc ~ forstrat
  Data: smallHerb_df
       AIC      BIC    logLik
  622.5854 632.2123 -307.2927

Correlation Structure: corPagel
 Formula: ~spp
 Parameter estimate(s):
   lambda
0.8820653

Coefficients:
               Value Std.Error  t-value p-value
(Intercept) 38.33962  5.749715 6.668090  0.0000
forstratG    2.76048  3.133622 0.880924  0.3809

 Correlation:
          (Intr)
forstratG -0.334

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.3733714 -0.4522659  0.4543259  1.3857327  4.3348791

Residual standard error: 15.36373
Degrees of freedom: 84 total; 82 residual
```

# Similar results with size as a covariate
## Arboreal hypothesis, with size as covariate, nlme BM
```
Generalized least squares fit by REML
  Model: oc ~ size + forstrat
  Data: smallHerb_df
       AIC      BIC    logLik
  630.1358 639.7136 -311.0679

Correlation Structure: corBrownian
 Formula: ~spp
 Parameter estimate(s):
numeric(0)

Coefficients:
                Value Std.Error  t-value p-value
(Intercept) 26.851077  9.328837 2.878288  0.0051
size         2.800490  1.542153 1.815962  0.0731
forstratG    6.470129  2.889273 2.239362  0.0279

 Correlation:
          (Intr) size
size      -0.470
forstratG -0.083 -0.212

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.1207301 -0.3506936  0.2197343  1.0446246  2.7543714

Residual standard error: 21.79885
Degrees of freedom: 84 total; 81 residual
```

## Arboreal hypothesis, with size as covariate, nlme Pagel
```
Generalized least squares fit by REML
  Model: oc ~ size + forstrat
  Data: smallHerb_df
       AIC     BIC    logLik
  617.6568 629.629 -303.8284

Correlation Structure: corPagel
 Formula: ~spp
 Parameter estimate(s):
   lambda
0.8796577

Coefficients:
                Value Std.Error  t-value p-value
(Intercept) 29.960189  6.869210 4.361519  0.0000
size         2.937445  1.381793 2.125821  0.0366
forstratG    1.278116  3.143115 0.406640  0.6853

 Correlation:
          (Intr) size
size      -0.577
forstratG -0.145 -0.212

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.5333318 -0.3963309  0.3337985  1.3537340  4.0964780

Residual standard error: 14.99432
Degrees of freedom: 84 total; 81 residual
```

# Orbit convergence is not associated with herbivory, regardless of phylogenetic model or including size as a covariate
## Herbivore hypothesis, no interaction, nlme BM
```
Generalized least squares fit by REML
  Model: oc ~ herb
  Data: smallHerb_df
       AIC      BIC    logLik
  640.4299 647.6501 -317.2149

Correlation Structure: corBrownian
 Formula: ~spp
 Parameter estimate(s):
numeric(0)

Coefficients:
               Value Std.Error  t-value p-value
(Intercept) 38.55141  8.838917 4.361553   0.000
herbyes      1.32618  3.393877 0.390756   0.697

 Correlation:
        (Intr)
herbyes -0.277

Standardized residuals:
       Min         Q1        Med         Q3        Max
-0.8639605 -0.2503023  0.3568618  0.9093730  2.9478373

Residual standard error: 23.00752
Degrees of freedom: 84 total; 82 residual
```

## Herbivore hypothesis, no interaction, nlme Pagel
```
Generalized least squares fit by REML
  Model: oc ~ herb
  Data: smallHerb_df
       AIC      BIC    logLik
  622.4043 632.0312 -307.2022

Correlation Structure: corPagel
 Formula: ~spp
 Parameter estimate(s):
   lambda
0.8623888

Coefficients:
               Value Std.Error  t-value p-value
(Intercept) 38.04584  5.699914 6.674810  0.0000
herbyes      2.82504  3.091456 0.913821  0.3635

 Correlation:
        (Intr)
herbyes -0.398

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.3962999 -0.4078229  0.5199369  1.3962666  4.4709903

Residual standard error: 14.94727
Degrees of freedom: 84 total; 82 residual
```

## Herbivore hypothesis, with size as covariate, no interaction, nlme BM
```
Generalized least squares fit by REML
  Model: oc ~ size + herb
  Data: smallHerb_df
       AIC      BIC    logLik
  634.5868 644.1646 -313.2934

Correlation Structure: corBrownian
 Formula: ~spp
 Parameter estimate(s):
numeric(0)

Coefficients:
                Value Std.Error   t-value p-value
(Intercept) 27.480175  9.885143 2.7799472  0.0068
size         3.548595  1.551296 2.2875040  0.0248
herbyes      1.482166  3.310239 0.4477519  0.6555

 Correlation:
        (Intr) size
size    -0.490
herbyes -0.251  0.021

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.0571269 -0.2675697  0.2886813  0.8626666  2.6997615

Residual standard error: 22.43576
Degrees of freedom: 84 total; 81 residual
```

## Herbivore hypothesis, with size as covariate, no interaction, nlme Pagel
```
Generalized least squares fit by REML
  Model: oc ~ size + herb
  Data: smallHerb_df
       AIC      BIC    logLik
  617.3529 629.3251 -303.6764

Correlation Structure: corPagel
 Formula: ~spp
 Parameter estimate(s):
   lambda
0.8728437

Coefficients:
                Value Std.Error  t-value p-value
(Intercept) 29.170649  6.963565 4.189039  0.0001
size         2.940278  1.351968 2.174814  0.0326
herbyes      2.161749  3.039665 0.711180  0.4790

 Correlation:
        (Intr) size
size    -0.582
herbyes -0.257 -0.102

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.5583770 -0.4172078  0.4429393  1.2910007  4.1367038

Residual standard error: 14.82226
Degrees of freedom: 84 total; 81 residual
```

# Pagel's lambda models significantly more likely; therefore concluding that orbit convergence is NOT significantly associated with arboreality or herbivory after phylogenetic correction
```
Arboreal BM vs arboreal Pagel
Likelihood ratio = 13.521(df=1) P = 0.0002359
Arboreal BM vs arboreal Pagel; both with size as covariate
Likelihood ratio = 14.479(df=1) P = 0.0001417
Herbivore BM vs herbivore Pagel
Likelihood ratio = 20.026(df=1) P = 7.641e-06
Herbivore BM vs herbivore Pagel; both with size as covariate
Likelihood ratio = 19.234(df=1) P = 1.156e-05
```

# No support for the hypothesis that small prey species have lower orbit convergence
## Small herbivore (prey) hypothesis, no interaction, nlme BM
```
Generalized least squares fit by REML
  Model: oc ~ size + forstrat + herb
  Data: smallHerb_df
       AIC      BIC    logLik
  626.7982 638.7083 -308.3991

Correlation Structure: corBrownian
 Formula: ~spp
 Parameter estimate(s):
numeric(0)

Coefficients:
                Value Std.Error  t-value p-value
(Intercept) 24.029882  9.702895 2.476568  0.0154
size         2.746163  1.542060 1.780841  0.0787
forstratG    7.245524  2.980513 2.430966  0.0173
herbyes      3.481698  3.317833 1.049389  0.2972

 Correlation:
          (Intr) size   frstrG
size      -0.442
forstratG -0.146 -0.214
herbyes   -0.277 -0.034  0.248

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.1756233 -0.3889281  0.2857650  1.0909092  2.7029468

Residual standard error: 21.78524
Degrees of freedom: 84 total; 80 residual
```

## Small herbivore (prey) hypothesis, no interaction, nlme Pagel
```
Generalized least squares fit by REML
  Model: oc ~ size + forstrat + herb
  Data: smallHerb_df
       AIC     BIC    logLik
  614.9008 629.193 -301.4504

Correlation Structure: corPagel
 Formula: ~spp
 Parameter estimate(s):
   lambda
0.8868948

Coefficients:
                Value Std.Error  t-value p-value
(Intercept) 28.146879  7.229824 3.893163  0.0002
size         2.785118  1.399332 1.990320  0.0500
forstratG    1.952335  3.190414 0.611938  0.5423
herbyes      2.541878  3.099167 0.820181  0.4146

 Correlation:
          (Intr) size   frstrG
size      -0.508
forstratG -0.186 -0.230
herbyes   -0.280 -0.133  0.178

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.5598397 -0.4253012  0.4103154  1.3447269  4.0053465

Residual standard error: 15.17995
Degrees of freedom: 84 total; 80 residual
```

## Small herbivore (prey) hypothesis, with forstrat:herb interaction, nlme BM
```
Generalized least squares fit by REML
  Model: oc ~ size + forstrat + herb + forstrat:herb
  Data: smallHerb_df
       AIC     BIC    logLik
  621.8853 636.102 -304.9427

Correlation Structure: corBrownian
 Formula: ~spp
 Parameter estimate(s):
numeric(0)

Coefficients:
                      Value Std.Error    t-value p-value
(Intercept)       27.669117 10.107640  2.7374459  0.0076
size               2.877649  1.540616  1.8678558  0.0655
forstratG          1.394299  5.582315  0.2497708  0.8034
herbyes           -1.258524  5.059187 -0.2487601  0.8042
forstratG:herbyes  7.282974  5.882740  1.2380241  0.2194

 Correlation:
                  (Intr) size   frstrG herbys
size              -0.402
forstratG         -0.321 -0.172
herbyes           -0.393 -0.074  0.727
forstratG:herbyes  0.291  0.069 -0.847 -0.757

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.2232194 -0.4208696  0.3649956  1.1049428  2.6656970

Residual standard error: 21.71307
Degrees of freedom: 84 total; 79 residual
```

## Small herbivore (prey) hypothesis, with forstrat:herb interaction, nlme Pagel
```
Generalized least squares fit by REML
  Model: oc ~ size + forstrat + herb + forstrat:herb
  Data: smallHerb_df
       AIC      BIC    logLik
  610.9212 627.5073 -298.4606

Correlation Structure: corPagel
 Formula: ~spp
 Parameter estimate(s):
   lambda
0.8982571

Coefficients:
                      Value Std.Error   t-value p-value
(Intercept)       29.853009  7.649547  3.902585  0.0002
size               2.816009  1.403753  2.006058  0.0483
forstratG         -1.124659  4.867840 -0.231039  0.8179
herbyes           -0.166508  4.319213 -0.038550  0.9693
forstratG:herbyes  4.898210  5.247226  0.933486  0.3534

 Correlation:
                  (Intr) size   frstrG herbys
size              -0.476
forstratG         -0.331 -0.167
herbyes           -0.391 -0.108  0.612
forstratG:herbyes  0.285  0.024 -0.758 -0.696

tandardized residuals:
       Min         Q1        Med         Q3        Max
-1.5945862 -0.4758474  0.4841283  1.3610003  3.8711442

Residual standard error: 15.45379
Degrees of freedom: 84 total; 79 residual
```

## Small herbivore (prey) hypothesis, with size:herb interaction, nlme BM
```
Generalized least squares fit by REML
  Model: oc ~ size + forstrat + herb + size:herb
  Data: smallHerb_df
       AIC      BIC    logLik
  624.6037 638.8204 -306.3019

Correlation Structure: corBrownian
 Formula: ~spp
 Parameter estimate(s):
numeric(0)

Coefficients:
                 Value Std.Error    t-value p-value
(Intercept)  27.626591 10.652308  2.5934841  0.0113
size          1.787340  1.932400  0.9249329  0.3578
forstratG     7.130582  2.989681  2.3850646  0.0195
herbyes      -3.558257  9.146264 -0.3890394  0.6983
size:herbyes  1.908605  2.310049  0.8262182  0.4112

 Correlation:
             (Intr) size   frstrG herbys
size         -0.568
forstratG    -0.152 -0.143
herbyes      -0.473  0.550  0.133
size:herbyes  0.409 -0.601 -0.047 -0.932

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.2254302 -0.3449113  0.3133760  1.0921795  2.6378387

Residual standard error: 21.82858
Degrees of freedom: 84 total; 79 residual
```

## Small herbivore (prey) hypothesis, with interaction, nlme Pagel
```
Generalized least squares fit by REML
  Model: oc ~ size + forstrat + herb + size:herb
  Data: smallHerb_df
       AIC      BIC    logLik
  613.5112 630.0973 -299.7556

Correlation Structure: corPagel
 Formula: ~spp
 Parameter estimate(s):
  lambda
0.885405

Coefficients:
                 Value Std.Error   t-value p-value
(Intercept)  27.914895  8.544069  3.267166  0.0016
size          2.866852  1.944107  1.474637  0.1443
forstratG     1.908780  3.212919  0.594095  0.5541
herbyes       2.986302  8.132018  0.367228  0.7144
size:herbyes -0.132518  2.176049 -0.060898  0.9516

 Correlation:
             (Intr) size   frstrG herbys
size         -0.676
forstratG    -0.166 -0.156
herbyes      -0.578  0.600  0.082
size:herbyes  0.527 -0.690 -0.015 -0.924

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.5488126 -0.4261405  0.4062445  1.3364783  3.9947575

Residual standard error: 15.24299
Degrees of freedom: 84 total; 79 residual
```

# Pagel's lambda models have significantly higher likelihood
```
[1] "res_preySize_BM vs res_preySize_P"
Likelihood ratio = 13.897(df=1) P = 0.0001931
[1] "res_forstratHerbIntxn_BM vs res_forstratHerbIntxn_P"
Likelihood ratio = 12.964(df=1) P = 0.0003175
[1] "res_sizeHerbIntxn_BM vs res_sizeHerbIntxn_P"
Likelihood ratio = 13.093(df=1) P = 0.0002965
```

# Adding size as a covariate tends to improve models; adding an interaction between size and herbivory does not significantly improve the model
```
[1] "Size only vs foraging strategy w/ size as covariate:"
Likelihood ratio = 44.458(df=1) P = 2.598e-11
[1] "Foraging strategy only vs foraging strategy w/ size as covariate:"
Likelihood ratio = 6.9287(df=1) P = 0.008482
[1] "Herbivory only vs herbivory w/ size as covariate:"
Likelihood ratio = 7.0515(df=1) P = 0.00792
[1] "Foraging strategy only vs herbivory and foraging strategy w/ size as covariate:"
Likelihood ratio = 4.7559(df=1) P = 0.0292
[1] "herbivory and foraging strategy w/ size as covariate vs interaction between foraging strat and herb:"
Likelihood ratio = 5.9797(df=1) P = 0.01447
[1] "herbivory and foraging strategy w/ size as covariate vs interaction between size and herb:"
Likelihood ratio = 3.3896(df=1) P = 0.06561
```

# Conclusion: trend towards higher orbit convergence in arboreal species compared to ground foragers, but not significant
