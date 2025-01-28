#! /bin/bash
#chmod +x salon.sh

#Initial text

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

#Constant Data

PSQL="psql --username=freecodecamp --dbname=salon -t -c"
SERVICES=$($PSQL "SELECT service_id, name FROM services")

#Display list of services until a valid one is selected
while true; do
echo "$SERVICES" | while IFS=" | " read SERVICE_ID SERVICE_NAME
do 
  echo "$SERVICE_ID) $SERVICE_NAME"
done

read SERVICE_ID_SELECTED

SERVICE_EXISTS=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")

if [[ -n $SERVICE_EXISTS ]]
  then
  break
else 
  echo -e "\nI could not find that service. What would you like today?"
fi
done

#Input phone, if don't exist add customer, else continue
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

PHONE_EXIST=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")

if [[ -z $PHONE_EXIST ]]
  then
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME

  $PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')" >/dev/null
fi

#Input time, print and insert the appointment
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
echo -e "\nWhat time would you like your cut,$CUSTOMER_NAME?"
read SERVICE_TIME


SERVICE_NAME_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
echo -e "\nI have put you down for a$SERVICE_NAME_SELECTED at $SERVICE_TIME,$CUSTOMER_NAME."


CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
$PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')" >/dev/null




