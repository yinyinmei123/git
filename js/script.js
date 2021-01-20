var swiper = new Swiper('.swiper-container', {
    spaceBetween: 30,
    loop: true,
    autoplay: {
        delay: 5000,
        disableOnInteraction: false,
    },
    pagination: {
        el: '.swiper-pagination',
        clickable: true
    }
})

swiper.el.onmouseover = function(){
    swiper.autoplay.stop()
}

swiper.el.onmouseout = function(){
    swiper.autoplay.start()
}