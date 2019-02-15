function str = cut(testtime)

str = strsplit(testtime, 'T');  
str{2} = str{2}(1:8);

end