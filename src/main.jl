include("test.jl")
#Função que executa os testes - precisa que passe as dimensões de teste
#Salva os gráficos para o problema simétrico na pasta images
function main()
    dim=[2,5,10]
    plot_lines(dim)
end