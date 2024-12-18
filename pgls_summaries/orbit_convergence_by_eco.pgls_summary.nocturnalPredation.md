# Based on both Brownian motion and Pagel's lambda models, orbit convergence is not associated with predation
## Predator hypothesis, nlme BM
```
Generalized least squares fit by REML
  Model: oc ~ pred
  Data: noctPred_df
       AIC      BIC    logLik
  677.5202 684.8833 -335.7601

Correlation Structure: corBrownian
 Formula: ~spp
 Parameter estimate(s):
numeric(0)

Coefficients:
               Value Std.Error   t-value p-value
(Intercept) 39.82344  9.033565  4.408386  0.0000
predyes     -1.08620  4.583612 -0.236975  0.8132

 Correlation:
        (Intr)
predyes -0.108

Standardized residuals:
       Min         Q1        Med         Q3        Max
-0.8146318 -0.2344307  0.3123813  0.8620186  2.7893447

Residual standard error: 24.33423
Degrees of freedom: 88 total; 86 residual
```
## Predator hypothesis, nlme Pagel:
```
Generalized least squares fit by REML
  Model: oc ~ pred
  Data: noctPred_df
       AIC      BIC    logLik
  661.2264 671.0438 -326.6132

Correlation Structure: corPagel
 Formula: ~spp
 Parameter estimate(s):
   lambda
0.8375074

Coefficients:
               Value Std.Error   t-value p-value
(Intercept) 40.45929  5.405059  7.485448  0.0000
predyes     -1.23208  3.755241 -0.328096  0.7436

 Correlation:
        (Intr)
predyes -0.148

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.3244362 -0.4104560  0.4509268  1.3167602  4.3528413

Residual standard error: 15.44755
Degrees of freedom: 88 total; 86 residual
```

# Add size as covariate - still no significant association with predation with either phylogenetic model
## Predator hypothesis, with size as covariate, nlme BM
```
Generalized least squares fit by REML
  Model: oc ~ size + pred
  Data: noctPred_df
      AIC      BIC    logLik
  673.203 682.9736 -332.6015

Correlation Structure: corBrownian
 Formula: ~spp
 Parameter estimate(s):
numeric(0)

Coefficients:
                Value Std.Error    t-value p-value
(Intercept) 30.630404 10.150688  3.0175692  0.0034
size         3.051323  1.618724  1.8850173  0.0628
predyes     -1.812549  4.533453 -0.3998163  0.6903

 Correlation:
        (Intr) size
size    -0.480
predyes -0.054 -0.085
Standardized residuals:
       Min         Q1        Med         Q3        Max
-0.9556992 -0.2454090  0.2708263  0.7940388  2.5624132

Residual standard error: 23.98085
Degrees of freedom: 88 total; 85 residual
```

## Predator hypothesis, with size as covariate, nlme Pagel
```
Generalized least squares fit by REML
  Model: oc ~ size + pred
  Data: noctPred_df
       AIC      BIC    logLik
  657.5022 669.7154 -323.7511

Correlation Structure: corPagel
 Formula: ~spp
 Parameter estimate(s):
   lambda
0.8448885

Coefficients:
               Value Std.Error   t-value p-value
(Intercept) 32.54112  6.937375  4.690697  0.0000
size         2.50594  1.384034  1.810608  0.0737
predyes     -1.46517  3.714879 -0.394405  0.6943

 Correlation:
        (Intr) size
size    -0.628
predyes -0.093 -0.034

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.4475774 -0.3900168  0.4106503  1.2151514  4.0521752

Residual standard error: 15.38189
Degrees of freedom: 88 total; 85 residual
```

# Orbit convergence is not associated with activity pattern, regardless of phylogenetic model and regardless of whether or not size is considered as a covariate
## Nocturnal hypothesis, nlme BM
```
Generalized least squares fit by REML
  Model: oc ~ activity
  Data: noctPred_df
       AIC     BIC    logLik
  677.2164 686.987 -334.6082

Correlation Structure: corBrownian
 Formula: ~spp
 Parameter estimate(s):
numeric(0)

Coefficients:
                 Value Std.Error  t-value p-value
(Intercept)   38.88593  9.143667 4.252773  0.0001
activitydark   0.49584  2.170313 0.228465  0.8198
activitylight  1.47295  2.347368 0.627488  0.5320

 Correlation:
              (Intr) actvtyd
activitydark  -0.150
activitylight -0.111  0.272

Standardized residuals:
       Min         Q1        Med         Q3        Max
-0.7934273 -0.2157717  0.3205215  0.8367935  2.7567280

Residual standard error: 24.42792
Degrees of freedom: 88 total; 85 residual

         Simultaneous Tests for General Linear Hypotheses

Multiple Comparisons of Means: Tukey Contrasts


Fit: gls(model = oc ~ activity, data = noctPred_df, correlation = corBM)

Linear Hypotheses:
                     Estimate Std. Error z value Pr(>|z|)
dark - complex == 0    0.4958     2.1703   0.228    0.971
light - complex == 0   1.4729     2.3474   0.627    0.803
light - dark == 0      0.9771     2.7294   0.358    0.931
(Adjusted p values reported -- single-step method)
```

## Nocturnal hypothesis, nlme Pagel
```
Generalized least squares fit by REML
  Model: oc ~ activity
  Data: noctPred_df
       AIC      BIC    logLik
  658.7973 671.0105 -324.3986

Correlation Structure: corPagel
 Formula: ~spp
 Parameter estimate(s):
   lambda
0.8305905

Coefficients:
                 Value Std.Error  t-value p-value
(Intercept)   37.83963  5.671608 6.671763  0.0000
activitydark   2.69741  2.848508 0.946955  0.3463
activitylight  3.19111  2.802744 1.138567  0.2581

 Correlation:
              (Intr) actvtyd
activitydark  -0.346
activitylight -0.278  0.502

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.3429428 -0.3965041  0.4604274  1.3563484  4.3595881

Residual standard error: 15.29256
Degrees of freedom: 88 total; 85 residual

         Simultaneous Tests for General Linear Hypotheses

Multiple Comparisons of Means: Tukey Contrasts


Fit: gls(model = oc ~ activity, data = noctPred_df, correlation = corPagel)

Linear Hypotheses:
                     Estimate Std. Error z value Pr(>|z|)
dark - complex == 0    2.6974     2.8485   0.947    0.610
light - complex == 0   3.1911     2.8027   1.139    0.490
light - dark == 0      0.4937     2.8196   0.175    0.983
(Adjusted p values reported -- single-step method)
```

## Nocturnal hypothesis, with size as covariate, nlme BM
```
Generalized least squares fit by REML
  Model: oc ~ size + activity
  Data: noctPred_df
       AIC      BIC    logLik
  673.0743 685.2284 -331.5372

Correlation Structure: corBrownian
 Formula: ~spp
 Parameter estimate(s):
numeric(0)

Coefficients:
                  Value Std.Error   t-value p-value
(Intercept)   29.639305 10.334099 2.8681073  0.0052
size           2.986516  1.629253 1.8330592  0.0703
activitydark   0.787449  2.146698 0.3668188  0.7147
activitylight  1.264250  2.318240 0.5453489  0.5870

 Correlation:
              (Intr) size   actvtyd
size          -0.488
activitydark  -0.167  0.074
activitylight -0.073 -0.049  0.267

Standardized residuals:
       Min         Q1        Med         Q3        Max
-0.8973746 -0.2314235  0.2457020  0.7955298  2.5526333

Residual standard error: 24.09569
Degrees of freedom: 88 total; 84 residual

         Simultaneous Tests for General Linear Hypotheses

Multiple Comparisons of Means: Tukey Contrasts


Fit: gls(model = oc ~ size + activity, data = noctPred_df, correlation = corBM)

Linear Hypotheses:
                     Estimate Std. Error z value Pr(>|z|)
dark - complex == 0    0.7874     2.1467   0.367    0.928
light - complex == 0   1.2642     2.3182   0.545    0.847
light - dark == 0      0.4768     2.7061   0.176    0.983
(Adjusted p values reported -- single-step method)
```

## Nocturnal hypothesis, with size as covariate, nlme Pagel:
```
Generalized least squares fit by REML
  Model: oc ~ size + activity
  Data: noctPred_df
       AIC      BIC    logLik
  655.1617 669.7466 -321.5809

Correlation Structure: corPagel
 Formula: ~spp
 Parameter estimate(s):
   lambda
0.8370245

Coefficients:
                  Value Std.Error  t-value p-value
(Intercept)   29.887533  7.191684 4.155846  0.0001
size           2.477342  1.390283 1.781898  0.0784
activitydark   3.019223  2.812350 1.073559  0.2861
activitylight  2.805081  2.762963 1.015244  0.3129

 Correlation:
              (Intr) size   actvtyd
size          -0.619
activitydark  -0.308  0.064
activitylight -0.170 -0.072  0.493

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.3749398 -0.4084106  0.4347859  1.2776259  4.0970140

Residual standard error: 15.21231
Degrees of freedom: 88 total; 84 residual

         Simultaneous Tests for General Linear Hypotheses

Multiple Comparisons of Means: Tukey Contrasts


Fit: gls(model = oc ~ size + activity, data = noctPred_df, correlation = corPagel)

Linear Hypotheses:
                     Estimate Std. Error z value Pr(>|z|)
dark - complex == 0    3.0192     2.8124   1.074    0.531
light - complex == 0   2.8051     2.7630   1.015    0.567
light - dark == 0     -0.2141     2.8080  -0.076    0.997
(Adjusted p values reported -- single-step method)
```

# No support for the nocturnal predation hypothesis (no significant interaction between activity pattern and predation)
## Nocturnal predation hypothesis, nlme BM

```
Generalized least squares fit by REML
  Model: oc ~ pred + activity + pred:activity
  Data: noctPred_df
       AIC      BIC    logLik
  668.0949 684.9419 -327.0474

Correlation Structure: corBrownian
 Formula: ~spp
 Parameter estimate(s):
numeric(0)

Coefficients:
                         Value Std.Error   t-value p-value
(Intercept)           38.99545  9.796150  3.980692  0.0001
predyes               -0.74743  6.187246 -0.120801  0.9041
activitydark           0.78342  4.724231  0.165830  0.8687
activitylight          0.94348  3.560709  0.264971  0.7917
predyes:activitydark  -0.52058  5.318521 -0.097881  0.9223
predyes:activitylight  1.27022  4.967454  0.255709  0.7988

 Correlation:
                      (Intr) predys actvtyd actvtyl prdys:ctvtyd
predyes               -0.278
activitydark          -0.328  0.611
activitylight         -0.225  0.337  0.498
predyes:activitydark   0.287 -0.644 -0.881  -0.436
predyes:activitylight  0.148 -0.302 -0.365  -0.718   0.366

Standardized residuals:
       Min         Q1        Med         Q3        Max
-0.7960060 -0.2057570  0.3050469  0.8395590  2.7270620

Residual standard error: 24.84764
Degrees of freedom: 88 total; 82 residual
```

## Nocturnal predation hypothesis, nlme Pagel
```
Generalized least squares fit by REML
  Model: oc ~ pred + activity + pred:activity
  Data: noctPred_df
       AIC      BIC    logLik
  649.4616 668.7153 -316.7308

Correlation Structure: corPagel
 Formula: ~spp
 Parameter estimate(s):
   lambda
0.8211731

Coefficients:
                         Value Std.Error   t-value p-value
(Intercept)           38.34865  6.112246  6.274068  0.0000
predyes               -1.66768  5.443628 -0.306355  0.7601
activitydark           2.05043  3.971957  0.516226  0.6071
activitylight          3.78507  3.865481  0.979197  0.3304
predyes:activitydark   1.83103  5.716512  0.320305  0.7496
predyes:activitylight -1.85548  5.787635 -0.320593  0.7493

 Correlation:
                      (Intr) predys actvtyd actvtyl prdys:ctvtyd
predyes               -0.346
activitydark          -0.470  0.540
activitylight         -0.381  0.379  0.610
predyes:activitydark   0.304 -0.698 -0.665  -0.392
predyes:activitylight  0.231 -0.432 -0.408  -0.660   0.433

Standardized residuals:
       Min         Q1        Med         Q3        Max
-1.3270170 -0.4383899  0.5080609  1.3259134  4.2652702

Residual standard error: 15.37213
Degrees of freedom: 88 total; 82 residual
```

## Nocturnal predation hypothesis, with size as covariate, nlme BM
```
Generalized least squares fit by REML
  Model: oc ~ size + pred + activity + pred:activity
  Data: noctPred_df
       AIC      BIC    logLik
  663.6419 682.7975 -323.8209

Correlation Structure: corBrownian
 Formula: ~spp
 Parameter estimate(s):
numeric(0)

Coefficients:
                          Value Std.Error    t-value p-value
(Intercept)           29.291305 10.909353  2.6849718  0.0088
size                   3.194938  1.679410  1.9024167  0.0607
predyes               -1.408937  6.100656 -0.2309485  0.8179
activitydark           1.162874  4.654818  0.2498215  0.8034
activitylight          0.147689  3.530041  0.0418378  0.9667
predyes:activitydark  -0.733838  5.236762 -0.1401321  0.8889
predyes:activitylight  2.552694  4.936220  0.5171353  0.6065

 Correlation:
                      (Intr) size   predys actvtyd actvtyl prdys:ctvtyd
size                  -0.468
predyes               -0.219 -0.057
activitydark          -0.310  0.043  0.607
activitylight         -0.142 -0.118  0.340  0.489
predyes:activitydark   0.264 -0.021 -0.642 -0.881  -0.430
predyes:activitylight  0.065  0.137 -0.307 -0.355  -0.722   0.359

Standardized residuals:
       Min         Q1        Med         Q3        Max
-0.9098185 -0.2339284  0.2576000  0.7814330  2.5308609

Residual standard error: 24.46007
Degrees of freedom: 88 total; 81 residual
```

## Nocturnal predation hypothesis, with size as covariate, nlme Pagel
```
Generalized least squares fit by REML
  Model: oc ~ size + pred + activity + pred:activity
  Data: noctPred_df
       AIC      BIC    logLik
  646.0785 667.6285 -314.0392

Correlation Structure: corPagel
 Formula: ~spp
 Parameter estimate(s):
   lambda
0.8329414

Coefficients:
                          Value Std.Error   t-value p-value
(Intercept)           30.780655  7.592128  4.054286  0.0001
size                   2.452874  1.454227  1.686720  0.0955
predyes               -2.148337  5.389570 -0.398610  0.6912
activitydark           2.138786  3.932162  0.543921  0.5880
activitylight          2.469156  3.872873  0.637552  0.5256
predyes:activitydark   1.792600  5.629323  0.318440  0.7510
predyes:activitylight  0.391684  5.814579  0.067362  0.9465

 Correlation:
                      (Intr) size   predys actvtyd actvtyl prdys:ctvtyd
size                  -0.590
predyes               -0.247 -0.049
activitydark          -0.384  0.017  0.540
activitylight         -0.188 -0.184  0.380  0.594
predyes:activitydark   0.245 -0.003 -0.696 -0.668  -0.386

tandardized residuals:
       Min         Q1        Med         Q3        Max
-1.3536470 -0.4247487  0.5024578  1.2299679  4.0183726

Residual standard error: 15.40253
Degrees of freedom: 88 total; 81 residual
```

# Pagel's lambda models have significantly higher likelihood
```
[1] "res_pred_BM vs res_pred_P"
Likelihood ratio = 18.294(df=1) P = 1.893e-05
[1] "res_predSize_BM vs res_predSize_P"
Likelihood ratio = 17.701(df=1) P = 2.585e-05
[1] "res_act_BM vs res_act_P"
Likelihood ratio = 20.419(df=1) P = 6.22e-06
[1] "res_actSize_BM vs res_actSize_P"
Likelihood ratio = 19.913(df=1) P = 8.106e-06
[1] "res_predAct_BM vs res_predAct_P"
Likelihood ratio = 20.633(df=1) P = 5.562e-06
[1] "res_predActSize_BM vs res_predActSize_P"
Likelihood ratio = 19.563(df=1) P = 9.732e-06
```

# Considering size as a covariate does not significantly improve models; considering both activity pattern and predation improves models compared to considerinig just one or the other
```
[1] "Size only vs predation w/ size as covariate:"
Likelihood ratio = 4.613(df=1) P = 0.03173
[1] "Predation only vs predation w/ size as covariate:"
Likelihood ratio = 5.7242(df=1) P = 0.01673
[1] "Size only vs activity pattern w/ size as covariate:"
Likelihood ratio = 8.9534(df=2) P = 0.01137
[1] "Activity patterns only vs activity pattern w/ size as covariate:"
Likelihood ratio = 5.6356(df=1) P = 0.0176
[1] "Predation only vs predation and activity pattern:"
Likelihood ratio = 19.765(df=4) P = 0.0005557
[1] "Activity only vs predation and activity pattern:"
Likelihood ratio = 15.336(df=3) P = 0.001551
[1] "Predation w/ size as covariate vs predation and activity pattern w/ size as covariate:"
Likelihood ratio = 19.424(df=4) P = 0.0006487
[1] "Activity w/ size as covariate vs predation and activity pattern w/ size as covariate:"
Likelihood ratio = 15.083(df=3) P = 0.001747
```

# Conclusion: Orbit convergence is not associated with predation or activity pattern after phylogenetic correction; no statistical support for the nocturnal predation hypothesis
