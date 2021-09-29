$(function () {
    $(".list-slick-wrap").slick({
        infinite: true,
        dots: true,
        dotsClass: "custom_paging",
        customPaging: function (slider, i) {
            console.log(slider);
            return i + 1 + "<em>/ " + slider.slideCount + "</em>";
        },
    });
});
