Add-Type -AssemblyName System.Windows.Forms

$Processos = @("nome_executavel1", "nome_executavel2", "nome_executavel3");

function EncerrarProcesso($Processo) {
    taskkill /f /im "$($Processo).exe"
}

function NovoObjetoForm($ObjectType, $ObjectText, $ObjectSize, $ObjectPos) {
    $Object = New-Object "System.Windows.Forms.$($ObjectType)";
    $Object.Text = $ObjectText;
    $Object.Size = New-Object System.Drawing.Size($ObjectSize[0], $ObjectSize[1]);
    $Object.Location = New-Object System.Drawing.Point($ObjectPos[0], $ObjectPos[1]);
    return $Object;
}

function RealizaPesquisaProcessos($Termo) {
    $Nomes = [System.Collections.ArrayList]::new();
    Get-Process | ForEach-Object {
        if ("$($_)".ToLower().Contains($Termo.ToLower().Trim()) -and -not $Nomes.Contains("$($_.Name)")) {
	        $Nomes.Add($_.Name);
        }
    }
    if ($Nomes.Count -gt 0) {
        $NovoForm = NovoObjetoForm "Form" "Os processos encontrados foram:" @(260, ($Nomes.Count * 30 + 80)) @(0,0);
        foreach ($Nome in $Nomes) {
            $Botao = NovoObjetoForm "Button" $Nome @(200, 25) @(20, ($NovoForm.Controls.Count * 30 + 20));
            $Botao.Add_Click({ EncerrarProcesso $this.Text })
            $NovoForm.Controls.Add($Botao);
        }
    } else {
        $NovoForm = NovoObjetoForm "Form" "Nenhum processo encontrado:" @(260, 130) @(0,0);
        $Label = NovoObjetoForm "Label" "Eh gurizada, alguem garoteou!`n`nNao achei nenhum processo`nque contenha o nome: $($Termo)" @(200, 100) @(20, ($NovoForm.Controls.Count * 30 + 20));
        $NovoForm.Controls.Add($Label);
    }
    $NovoForm.Show();
}

$Form = NovoObjetoForm "Form" "Encerrar Processos" @(260, ($Processos.Count * 20 + 250)) @(0,0);

foreach ($NomeProcesso in $Processos) {
    $Botao = NovoObjetoForm "Button" $NomeProcesso @(200, 25) @(20, ($Form.Controls.Count * 30 + 20));
    $Botao.Add_Click({ EncerrarProcesso $this.Text });
    $Form.Controls.Add($Botao);
}

$TextBox = NovoObjetoForm "TextBox" "" @(200, 25) @(20, ($Form.Controls.Count * 30 + 60));
$Form.Controls.Add($textBox);
$Pesquisar = NovoObjetoForm "Button" "Pesquisar" @(200, 25) @(20, ($Form.Controls.Count * 30 + 80));
$Pesquisar.Add_Click({ RealizaPesquisaProcessos $TextBox.Text });
$Form.Controls.Add($Pesquisar);

$Form.ShowDialog();
