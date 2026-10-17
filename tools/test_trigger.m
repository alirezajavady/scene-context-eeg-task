% TEST_TRIGGER  Check the trigger box -> EEG amplifier link by sending
% trigger 20 ten times, once every 2 seconds.

port = '/dev/ttyUSB0'; % e.g. 'COM3' on Windows

instrreset
a = serial(port, 'BaudRate', 57600, 'DataBits', 8);
fopen(a);
fwrite(a, 0);

for i = 1:10
    fwrite(a, 20)
    pause(2);
end
