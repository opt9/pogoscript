$(function () {
    $('pre > code').each(function () {
        this.innerHTML = this.innerHTML
            .replace(/([:=*+/-])/g, '<span class="operator">$1</span>')
            .replace(/(@[a-zA-Z_$]+)/g, '<span class="argument">$1</span>')
            .replace(/(\?[a-zA-Z_$]+)/g, '<span class="parameter">$1</span>')
            ;
    });
});
