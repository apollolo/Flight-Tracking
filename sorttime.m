function outv = sorttime(mat)

id = mat(1,:);
hr = mat(2,:);
        for i=1:length(hr)-1
            indlow=i;
            for j=i+1:length(hr)
                if hr(j) < hr(indlow)
                indlow=j;
                end
            end
        temp=hr(i);
        hr(i)=hr(indlow);
        hr(indlow)=temp;
        
        temp=id(i);
        id(i)=id(indlow);
        id(indlow)=temp;
    end
outv=id;
end