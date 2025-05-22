sleep 5
echo "Setting AT+CFUN=0"
echo -ne 'AT+CFUN=0\r\n' > /dev/ttyUSB2
sleep 5
echo "Setting AT+CFUN=1"
echo -ne 'AT+CFUN=1\r\n' > /dev/ttyUSB2
sleep 5
echo "ifdown wwan0"
ifdown wwan0
sleep 5
echo "ifup wwan0"
ifup wwan0
sleep 1
