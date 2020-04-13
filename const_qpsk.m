function y=const_qpsk(xh)
close
p=[1+1i 1-1i -1+1i -1-1i].*1/sqrt(2);
% Boundaries
b = ceil(max(abs(max(real(xh))),abs(max(imag(xh)))));
v = [b*1i -b*1i];   % Vertical Line
hold on
plot(xh,'m.') % Received Symbols
xlabel('In-phase Component')
ylabel('Quatrature Component')
%title(['Received Symbols for SNR = ' num2str(snr_db) 'dB'])
plot(p,'ko')    % Symbol Constellations
plot(v,'k')
plot(-b:b,zeros(1,2*b+1),'k')   % Horizontal Boundary
%legend('RX symbols','16QAM Symbols','Decision Boundary')
grid on
hold off
end