document.addEventListener('DOMContentLoaded', function() {
    // Cấu hình phân trang
    const itemsPerPage = 8;
    const productItems = document.querySelectorAll('.product-item');
    const totalItems = productItems.length;
    const totalPages = Math.ceil(totalItems / itemsPerPage);
    let currentPage = 1;

    // Hàm hiển thị sản phẩm theo trang
    function displayProducts(page) {
        // Ẩn tất cả sản phẩm
        productItems.forEach(item => {
            item.classList.remove('active');
        });

        // Tính toán sản phẩm bắt đầu và kết thúc cho trang hiện tại
        const startIndex = (page - 1) * itemsPerPage;
        const endIndex = Math.min(startIndex + itemsPerPage - 1, totalItems - 1);

        // Hiển thị sản phẩm cho trang hiện tại
        for (let i = startIndex; i <= endIndex; i++) {
            if (productItems[i]) {
                productItems[i].classList.add('active');
            }
        }

        // Cập nhật trạng thái phân trang
        updatePagination(page);

        // Cuộn lên đầu danh sách sản phẩm
        document.getElementById('product-grid').scrollIntoView({behavior: 'smooth', block: 'start'});
    }

    // Hàm cập nhật giao diện phân trang
    function updatePagination(page) {
        const paginationElement = document.getElementById('pagination');
        paginationElement.innerHTML = '';

        // Nút Previous
        if (page > 1) {
            const prevButton = createPageButton('prev', '<i class="fa fa-angle-left"></i> Previous', () => {
                currentPage--;
                displayProducts(currentPage);
            });
            paginationElement.appendChild(prevButton);
        }

        // Hiển thị các nút số trang
        if (totalPages <= 5) {
            // Hiển thị tất cả các trang nếu ít hơn hoặc bằng 5 trang
            for (let i = 1; i <= totalPages; i++) {
                paginationElement.appendChild(createPageNumberButton(i, page));
            }
        } else {
            // Hiển thị trang đầu tiên
            if (page > 3) {
                paginationElement.appendChild(createPageNumberButton(1, page));

                // Hiển thị dấu ...
                const dotsElement = document.createElement('span');
                dotsElement.className = 'page-link dots';
                dotsElement.textContent = '...';
                paginationElement.appendChild(dotsElement);
            }

            // Hiển thị các trang xung quanh trang hiện tại
            const startPage = Math.max(1, page - 1);
            const endPage = Math.min(totalPages, page + 1);

            for (let i = startPage; i <= endPage; i++) {
                paginationElement.appendChild(createPageNumberButton(i, page));
            }

            // Hiển thị trang cuối cùng
            if (page < totalPages - 2) {
                // Hiển thị dấu ...
                const dotsElement = document.createElement('span');
                dotsElement.className = 'page-link dots';
                dotsElement.textContent = '...';
                paginationElement.appendChild(dotsElement);

                paginationElement.appendChild(createPageNumberButton(totalPages, page));
            }
        }

        // Nút Next
        if (page < totalPages) {
            const nextButton = createPageButton('next', 'Next <i class="fa fa-angle-right"></i>', () => {
                currentPage++;
                displayProducts(currentPage);
            });
            paginationElement.appendChild(nextButton);
        }
    }

    // Hàm tạo nút trang
    function createPageButton(type, html, clickHandler) {
        const button = document.createElement('a');
        button.className = 'page-link ' + type;
        button.innerHTML = html;
        button.addEventListener('click', clickHandler);
        return button;
    }

    // Hàm tạo nút số trang
    function createPageNumberButton(pageNumber, currentPage) {
        const button = document.createElement(pageNumber === currentPage ? 'span' : 'a');
        button.className = 'page-link' + (pageNumber === currentPage ? ' active' : '');
        button.textContent = pageNumber;

        if (pageNumber !== currentPage) {
            button.addEventListener('click', () => {
                currentPage = pageNumber;
                displayProducts(currentPage);
            });
        }

        return button;
    }

    // Khởi tạo phân trang ban đầu
    if (totalItems > 0) {
        displayProducts(currentPage);
    }
        document.addEventListener('DOMContentLoaded', function() {
        // Lắng nghe sự kiện thay đổi size
        const sizeSelects = document.querySelectorAll('.product-size-select');

        sizeSelects.forEach(select => {
        select.addEventListener('change', function() {
        const productId = this.getAttribute('data-product-id');
        const selectedOption = this.options[this.selectedIndex];
        const price = selectedOption.getAttribute('data-price');

        // Cập nhật hiển thị giá
        const priceElement = document.querySelector(`.product-item[data-product-id="${productId}"] .product-price`);
        if (priceElement) {
        priceElement.innerText = new Intl.NumberFormat('vi-VN').format(price) + ' VND';
    }
    });
    });
    });


});
