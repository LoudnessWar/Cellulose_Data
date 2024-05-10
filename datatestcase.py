# -*- coding: utf-8 -*-
"""DATATESTCASE.ipynb

Automatically generated by Colab.

Original file is located at
    https://colab.research.google.com/drive/1quTJogmruY1Vzk_JC9RdsAbJ8nxyuPot
"""

import numpy as np
import pandas as pd

import matplotlib.pyplot as plt

import os

from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split

from sklearn.ensemble import RandomForestRegressor
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score

#Here I am trying to determin which features best predict the DSI and what values result in the highest DSI

data = pd.read_csv('/content/combined.csv', index_col=0)# making id the index column
missing_values = data.isnull().sum()

# missing values have already been handled but it is better to be safe
data = data.dropna()

print("data head sample")
print(data.head())


#ok so I am not going to do feature sclaing because there are only 5 features and so There is no reason to really cut them down.

#splitiing data
y = data['DSI']
X = data.drop('DSI', axis=1)  # bc its target
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)#nopthing crazy here


#scaling
scaler = StandardScaler()
Xscal_test = scaler.fit_transform(X_test)
Xscal_train = scaler.fit_transform(X_train)

#Here I am going to use random foresddt to figure out which of the features of the cellulose data is best suited to predict the DSI
# I could use like PCA if I needed this to be faster but this doesnt need to be
ranfar = RandomForestRegressor()
ranfar.fit(Xscal_train, y_train)

feat_Imp = pd.DataFrame({
    'Feature': X_train.columns,
    'Importance': ranfar.feature_importances_
}).sort_values(by='Importance', ascending=False)

print("Feature Importance:")
print(feat_Imp)

#ok I am going to just use linear regression

lin_reg = LinearRegression()

lin_reg.fit(Xscal_train, y_train)

pred = lin_reg.predict(Xscal_test)

#MSE and R2
mse = mean_squared_error(y_test, y_pred)

r2 = r2_score(y_test, y_pred)

print("Error Values")
print("Mean Squared Error:", mse)
print("R2 Score:", r2)

#Coefficients associated with each feature
coefficients = pd.DataFrame({
    'Feature': X_train.columns,
    'Coefficient': lin_reg.coef_
})

print("Coefficients:")
print(coefficients)

# plot of pred vs actual of testing set not the best visualization
plt.figure(figsize=(7, 7))
plt.scatter(y_test, pred, alpha=0.6, color='b', s = 5 , label='DSI Predicted')
plt.plot([y_test.min(), y_test.max()], [y_test.min(), y_test.max()], 'r-', linewidth=1, label='Line of Perfection')

plt.xlabel('Actual')
plt.ylabel('Predicted')
plt.title('Predicted vs. Actual Plot')
plt.legend()
plt.show()

"""OK so this is pretty good but at the middle and end we can see that the actual and predicted deviate from the line of perfection."""