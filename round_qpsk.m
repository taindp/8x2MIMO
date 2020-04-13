function y=round_qpsk(z)
s=size(z);
r=s(1);
c=s(2);
amp=abs(z);
agr=angle(z);
y_dm=[];
for m=1:r
   for n=1:c
       y_dm(m,n)=round(z(m,n)*sqrt(2));
       if abs(y_dm(m,n))~=0
           y_dm(m,n)=z(m,n);
       else y_dm(m,n)=0;
       end
   end
end
y=y_dm;