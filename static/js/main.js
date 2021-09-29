$(function () {
    'use strict';

    /* GNB 열기, 닫기 */
    (function setGngToggle () {
        var $body = $('body');
        var $hd = $('.header');

        $('.js-toggle-menu').on('click', function (e) {
            e.preventDefault();
            
            var $wrap = $(this).closest('.gnb-wrap');
            var $btn = $('.js-toggle-menu');

            $wrap.toggleClass('is-expanded');
            $('body').toggleClass('is-menu-expanded');
            
            if ($wrap.hasClass('is-expanded')) {
                $btn.attr('aria-expanded', true);
                $wrap.find('input, textarea, select, button, a').get(0).focus();
            } else {
                $btn.attr('aria-expanded', false);
                $btn.get(0).focus();
            }
        });

        $('.js-toggle-total-search').on('click', function (e) {
            e.preventDefault();
            
            var $wrap = $(this).closest('.total-search-wrap');
            var $btn = $('.js-toggle-total-search');

            $wrap.toggleClass('is-expanded');
            
            if ($wrap.hasClass('is-expanded')) {
                $btn.attr('aria-expanded', true);
                $wrap.find('input, textarea, select, button, a').get(0).focus();
            } else {
                $btn.attr('aria-expanded', false);
                $btn.get(0).focus();
            }
        });

        $('.gnb-wrap, .total-search-wrap').on('keydown', function (e) {
            var keycode = e.keyCode || e.which;
            var $allEl = $(this).find('input, textarea, select, button, a');
            var firstEl = $allEl.get(0);
            var lastEl = $allEl.last().get(0);

            /* ESC Key */
            if (keycode == 27) {
                $btnClose.trigger('click');
            }

            /* Tab Key */
            if (keycode == 9 && !e.shiftKey && e.target === lastEl) {
                e.preventDefault();
                firstEl.focus();
            } else if (keycode == 9 && e.shiftKey && e.target === firstEl) {
                e.preventDefault();
                lastEl.focus();
            }
        });
    }());

    /* Toggle Item */
    (function toggleItem () {
        $('.js-toggle-item').on('click', function (e) {
            e.preventDefault();

            var $this = $(this);
            var target = $this.attr('href') || $this.attr('data-target');
            var $wrap = $(this).parent();

            if (!target) {
                return false;
            }
            
            $wrap.toggleClass('is-toggled');

            if ($wrap.hasClass('is-toggled')) {
                $this.attr('aria-expanded', true).addClass('is-trigger');
            } else {
                $this.attr('aria-expanded', false).removeClass('is-trigger');
            }
        });
    }());

    /* Dropdown 열기, 닫기 */
    (function setDropdown () {
        $('.js-toggle-dropdown').attr('aria-haspopup', 'listbox')
            .on('click', function (e) {
                e.preventDefault();
                var $this = $(this);
                var $wrap = $this.closest('.dropdown-wrap');
                var $activeItem = $('.dropdown-wrap.is-expanded');

                if ($activeItem.length && !$wrap.hasClass('is-expanded')) {
                    $activeItem.removeClass('is-expanded').find('.js-toggle-dropdown').attr('aria-expanded', false);
                }

                $wrap.toggleClass('is-expanded');

                if ($wrap.hasClass('is-expanded')) {
                    $this.attr('aria-expanded', true);
                } else {
                    $this.attr('aria-expanded', false);
                }
            })  
            .on('mouseenter', function (e) {
                $(this).attr('aria-expanded', true).closest('.dropdown-wrap').addClass('is-expanded');
            });
            

        $('.dropdown-wrap').on('mouseleave', function (e) {
            $(this).removeClass("is-expanded").find('.js-toggle-dropdown').attr('aria-expanded', false);
        });

        $('.dropdown-wrap .js-chg-val').on('click', function (e) {
            e.preventDefault();

            var $this = $(this);
            var val = $this.text();
            var $wrap = $this.closest('.dropdown-wrap');

            $this.parent().addClass('on').siblings().removeClass('on');
            $wrap.removeClass('is-expanded').find('.js-toggle-dropdown').text(val).get(0).focus();
        });
    }());

    /* 모달 팝업 설정 */
    (function setModalPopup () {

        /* 모달 팝업 열기 */
        window.openPopup = function (id, startEl) {
            var $target = $(id);
            var $startEl = (startEl ? $(startEl) : '');
            
            if ($target.length) {
                if ($startEl) {
                    $startEl.addClass('is-trigger');
                }

                setTimeout(function () {
                    $('body').addClass('has-modal').css('overflow', 'hidden').append('<div class="modal-backdrop"></div>');
                    $target.addClass('open').find('a, input, select, textarea, button').first().get(0).focus();
                }, 100);
            }
        };

        /* 모달 팝업 닫기 */
        window.closePopup = function (id) {
            var $target = $(id);
            var $beforeBtn = $('.is-trigger');

            if ($target.length) {
                $target.removeClass('open');
                $('body').removeClass("has-modal").css('overflow', '');

                if ($('.modal-popup.open').length <= 1) {
                    $('.modal-backdrop').remove();
                }
                
                if ($beforeBtn.length) {
                    $beforeBtn.removeClass('is-trigger').get(0).focus();
                }
            }
        };

        /* 기타 이벤트 */
        $(document).on('click', '.js-open-popup', function (e) {
            e.preventDefault();
            openPopup($(this).attr('href'), this);
        })
            .on('click', '.js-close-popup', function (e) {
                e.preventDefault();
                closePopup('#' + $(this).closest('.modal-popup').attr('id'));
            })
            .on('keydown', '.has-modal .modal-popup', function (e) {
                var $modal = $(this);
                var keycode = e.keycode || e.which;
                var current = e.target || e.srcElement;
                var firstEl = $modal.find('a, input, select, textarea, button').first().get(0) || null;
                var lastEl = $modal.find('a, input, select, textarea, button').last().get(0) || null;

                switch(keycode) {
                    case 27: // esc key
                        closePopup('#' + $(this).attr('id'));
                        break;
                    case 9: // tab key
                        if (lastEl && current === lastEl && !e.shiftKey) {
                            e.preventDefault();
                            firstEl.focus();
                        }
                        if (firstEl && current === firstEl && e.shiftKey ) {
                            e.preventDefault();
                            lastEl.focus();
                        }
                        break;
                    default:
                }
            });
    }());

    /* Tab 열기 */
    (function setTabs () {
        $('.tabs [role="tab"]').on('click', function (e) {
            e.preventDefault();

            var $tab = $(this);
            var target = $tab.attr('href') || $tab.attr('aria-controls');

            $tab.parent().addClass('on').attr('aria-selected', true).siblings().removeClass('on').attr('aria-selected', false);

            if (target && $(target).length) {
                $(target).addClass('on').siblings().removeClass('on');
            }

            if ($(target).find('.slick-slider').length) {
                $(target).find('.slick-slider').slick('setPosition').slick('slickGoTo', 0);
            }
        });

        $(window).on('load resize', function () {
            $('.tabs').each(function () {
                var $this = $(this);
                var $active = $this.find('.on');
                var xpos = 0;

                if ($active.length) {
                    xpos = $active.position().left + ($active.outerWidth() / 2) - (window.innerWidth / 2);
                    $this.scrollLeft(xpos);
                }
            });
        });
    }());

    /* List Filter 모바일 터치스크롤 */
    (function setListFilterScroll () {
        $('.list-filter').on("touchstart", function(e) {
            var touch = e.originalEvent.touches[0];
            var xInit = touch.pageX;
            var yInit = touch.pageY;
            var xCurrent, yCurrent, deltaX, deltaY, theta;
            var $list = $(this);
            var finalX = $list.offset().left;
            var maxpos = $list.parent().outerWidth() - $list.outerWidth();

            if (maxpos > 0) {
                return true;
            }

            $list.on("touchmove", function(ev) {
                var moveTouch = ev.originalEvent.touches[0];
                xCurrent = moveTouch.pageX;
                yCurrent = moveTouch.pageY;
                
                deltaX = xCurrent - xInit;
                deltaY = yCurrent - yInit;
            
                theta = Math.atan2(deltaY, deltaX);
                theta *= 180/Math.PI;
            
                if (Math.abs(deltaX) > 30 && Math.abs(deltaY) < 10) {
                    ev.preventDefault();
                    $list.addClass('is-moving');
                    
                    switch (true) {
                        case (-45 < theta && theta < 45):
                            finalX += (deltaX * 0.4);
                            if (finalX > 0) {
                                finalX = 0;
                            }
                            break;
                        case (-135 > theta || theta > 135):
                            finalX += (deltaX * 0.4);
                            if (finalX < maxpos) {
                                finalX = maxpos;
                            }
                            break;
                    }

                    $list.css('transform', 'translate('+ finalX +'px, 0px)');
                }
            });

            $list.on('touchend', function () {
                $list.on('touchmove', null)
                    .on('touchend', null)
                    .removeClass('is-moving');
            });
        })
            .each(function () {
                $(this).wrap('<div class="list-filter-wrap"></div>');
            });

        $(window).on('resize', function () {
            $('.list-filter').css('transform', '');
        });
    }());

    /* 윈도우 스크롤 이벤트 */ 
    (function setWatchScroll () {
        $(window).on('scroll', function () {
            var $body = $('body');
            var $hd = $('.header');
            var curpos = $(window).scrollTop();
            var minpos = $hd.outerHeight() * 2;

            if ($('.main-visual-wrap').length) {
                minpos = $hd.outerHeight() + $('.main-visual-wrap').outerHeight();
            }

            if ( curpos > minpos ) {
                $body.addClass('is-scrolled');
            } else {
                $body.removeClass('is-scrolled');
            }
        });
    }());

    /* 아코디언 목록 */
    (function toggleAccordionList () {
        $('.js-toggle-accordion').on('click', function (e) {
            e.preventDefault();
            $(this).parent().toggleClass('on');

            if($(this).parent().hasClass('on')) {
                $(this).attr('aria-expanded', true).attr('aria-disabled', true).parent().siblings().removeClass('on');
            } else {
                $(this).attr('aria-expanded', false).attr('aria-disabled', false);
            }
        });
    }());
});