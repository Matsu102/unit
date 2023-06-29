module ApplicationHelper

  def toastr_flash
    flash_messages = flash.each_with_object([]) do |(type, message), flash_messages|
      type = 'success' if type == 'notice'
      type = 'error' if type == 'alert'
      text = "<script>toastr.#{type}('#{message}', '', { closeButton: true, progressBar: true, positionClass: 'toast-top-center' })</script>"
      flash_messages << text.html_safe if message
    end
    flash_messages.join("\n").html_safe
  end

end
