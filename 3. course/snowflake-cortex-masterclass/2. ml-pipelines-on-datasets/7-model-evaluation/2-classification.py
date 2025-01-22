from matplotlib import pyplot
import seaborn as sns
import pandas as pd
from sklearn.model_selection import train_test_split
from xgboost import XGBClassifier
import sklearn.metrics as metrics
from sklearn.datasets import make_classification

# 10K random samples for classification
X, y = make_classification(n_samples=10000, n_features=6,
    n_informative=2, n_redundant=0, random_state=0, shuffle=True)

X = pd.DataFrame(X, columns=["X1", "X2", "X3", "X4", "X5", "X6"])
y = pd.DataFrame(y, columns=["Y"])
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.4)

clf = XGBClassifier()
clf.fit(X_train, y_train)

# ========================================================================
# Training accuracy: 0.984625 [1 1 1 ... 1 1 0]
train_data_pred = clf.predict(X_train)
print(train_data_pred)

# training_accuracy = clf.score(X_train, y_train)
training_accuracy = metrics.accuracy_score(y_train, train_data_pred)
print(f"Training accuracy: {training_accuracy}")

# Eval accuracy: 0.9495625 [0 1 0 ... 0 1 1]
test_data_pred = clf.predict(X_test)
print(test_data_pred)

# eval_accuracy = clf.score(X_test, y_test)
eval_accuracy = metrics.accuracy_score(y_test, test_data_pred)
print(f"Eval accuracy: {eval_accuracy}")

print('Precision:', metrics.precision_score(y_train, train_data_pred))
print('Recall:', metrics.recall_score(y_train, train_data_pred))
print('F1:', metrics.f1_score(y_train, train_data_pred))

matrix = metrics.confusion_matrix(y_train, train_data_pred)
pyplot.figure(figsize=(20, 20))
sns.heatmap(matrix, annot=True, fmt='.0f', cmap='Blues')
pyplot.show()