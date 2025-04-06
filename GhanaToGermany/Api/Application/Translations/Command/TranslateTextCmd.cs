using Api.Application.Common.Abstraction.Persistence;
using Api.Domain;
using Api.Infrastructure.Services;
using ErrorOr;
using MediatR;
using Shared.Translation;

namespace Api.Application.Translations.Command
{
    public record TranslateTextCmd(Guid PostId): IRequest<ErrorOr<TranslationModel>>;

    public class TranslateTextCmdHandler(IUnitOfWork unitOfWork, TranslationService translationService): IRequestHandler<TranslateTextCmd, ErrorOr<TranslationModel>>
    {
        public async Task<ErrorOr<TranslationModel>> Handle(TranslateTextCmd request, CancellationToken cancellationToken)
        {
            // check if there are any translations for postId
            var prevTranslation = await unitOfWork.Translation.FilterAsync([t => t.PostId == request.PostId]);
            if (prevTranslation.Any()) {
                var translation = prevTranslation.FirstOrDefault();

                return new TranslationModel {
                    Translation = translation!.TranslatedText,
                    Input = translation.Text
                };
            } else {
                // call translation service
                var post = await unitOfWork.Post.GetByIdAsync(request.PostId);

                if (post == null) return new Error[] { Error.NotFound("Post to be translated not found") };

                var translation = await translationService.TranslateText(post.Content);

                // save record
                var translationEntity = Translation.Create(post.Id, post.Content, translation);
                await unitOfWork.Translation.AddAsync(translationEntity);
                await unitOfWork.CommitAsync();

                return new TranslationModel {
                    Translation = translation,
                    Input = post.Content
                };
            }
        }
    }
}