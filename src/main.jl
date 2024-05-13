include("test.jl")
#Função que executa os testes - precisa que passe as dimensões de teste
#Salva os gráficos para o problema simétrico na pasta images
function main()
    dim=[2,5,10,50,100,250,500,750,1000,2500,5000,7500,8000,8500,9000,9500,10000]
    plot_lines(dim)
end