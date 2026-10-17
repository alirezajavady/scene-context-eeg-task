function send_trigger(p, a, trigger)
% SEND_TRIGGER  Write one trigger code (0-255) to the serial trigger box.
if p.usetrigs
    fwrite(a,trigger); %send trigger
end
